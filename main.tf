// Copyright 2022 Isovalent, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

// List of availability zones for the chosen region.
data "aws_availability_zones" "available" {
  state = "available"
}

// The VPC itself, as well as main subnets.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

  azs                     = local.availability_zones    // Use selected availability zones.
  cidr                    = var.cidr                    // Use the CIDR specified as a variable.
  enable_dns_hostnames    = true                        // Enable DNS hostnames (required by EKS).
  enable_nat_gateway      = true                        // Enable NAT gateway to enable outbound internet traffic from instances in a private subnet.
  name                    = var.name                    // Use the name specified as a variable.
  one_nat_gateway_per_az  = false                       // Use a single NAT gateway as that's the simplest and also all we need.
  secondary_cidr_blocks   = var.secondary_cidr_blocks   // Define secondary CIDR blocks.
  single_nat_gateway      = true                        // Use a single NAT gateway as that's the simplest and also all we need.
  tags                    = var.tags                    // Use the tags specified as a variable.
  map_public_ip_on_launch = var.map_public_ip_on_launch // Map public IP on launch for instances in public subnets.

  enable_ipv6                                    = var.enable_ipv6 // this will provide Amazon-provided IPv6 CIDR block which is a /56 block
  public_subnet_assign_ipv6_address_on_creation  = var.enable_ipv6 // this will help the EC2 to get the IPV6 address when it boots
  private_subnet_assign_ipv6_address_on_creation = var.enable_ipv6 // this will help the EC2 to get the IPV6 address when it boots

  // Create one private subnet per AZ (e.g. "10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24", ...).
  // This could surely have been made differently (possibly even sourced from a variable), but it suffices for the time being.
  private_subnets = [
    for i, v in local.availability_zones :
    cidrsubnet(var.cidr, 8, i)
  ]
  // Tag the private subnets adequately.
  private_subnet_tags = merge(
    var.additional_private_subnet_tags,
    {
      "eks-control-plane"               = "true"    // Mark the subnet as usable for setting up the EKS control-plane.
      "kubernetes.io/role/internal-elb" = "1"       // Required by AWS Load Balancer controller.
      "type"                            = "private" // Required by AWS Load Balancer controller.
    },
  )

  // Create one public subnet per AZ (e.g. "10.1.100.0/24", "10.1.101.0/24", "10.1.102.0/24", ...).
  // This could surely have been made differently (possibly even sourced from a variable), but it suffices for the time being.
  public_subnets = [
    for i, v in local.availability_zones :
    cidrsubnet(var.cidr, 8, 100 + i)
  ]
  // Tag the public subnets adequately.
  public_subnet_tags = merge(
    var.additional_public_subnet_tags,
    {
      "kubernetes.io/role/elb" = "1"      // Required by AWS Load Balancer controller.
      "type"                   = "public" // Required by AWS Load Balancer controller.
    },
  )
  //This is needed when enabling the IPV6 but will not hurt when the IPV6 is not enabled.
  private_subnet_ipv6_prefixes = [
    for i, v in local.availability_zones :
    i
  ]
  public_subnet_ipv6_prefixes = [
    for i, v in local.availability_zones :
    10 + i
  ]

}

// Used to wait for the secondary CIDRs to be listed, as otherwise the AWS API will *sometimes* throw errors.
resource "null_resource" "wait_for_secondary_cidrs" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-secondary-cidrs.sh ${module.vpc.vpc_id} ${var.region} ${1 + length(var.secondary_cidr_blocks)}"
  }
}

// Create the additional private subnets (if requested).
resource "aws_subnet" "additional_private_subnets" {
  count = length(var.additional_private_subnets)

  depends_on = [
    null_resource.wait_for_secondary_cidrs,
  ]

  availability_zone = var.additional_private_subnets[count.index].availability_zone
  cidr_block        = var.additional_private_subnets[count.index].cidr
  tags              = var.additional_private_subnets[count.index].tags
  vpc_id            = module.vpc.vpc_id
}

resource "aws_route_table_association" "additional_private_subnets" {
  count = length(aws_subnet.additional_private_subnets)

  subnet_id      = aws_subnet.additional_private_subnets[count.index].id
  route_table_id = module.vpc.private_route_table_ids[0]
}

// Create the additional public subnets (if requested).
resource "aws_subnet" "additional_public_subnets" {
  count = length(var.additional_public_subnets) > 0 ? length(var.additional_public_subnets) : 0

  depends_on = [
    null_resource.wait_for_secondary_cidrs,
  ]

  availability_zone       = var.additional_public_subnets[count.index].availability_zone
  cidr_block              = var.additional_public_subnets[count.index].cidr
  map_public_ip_on_launch = true
  tags                    = var.additional_public_subnets[count.index].tags
  vpc_id                  = module.vpc.vpc_id
}

resource "aws_route_table_association" "additional_public_subnets" {
  count = length(aws_subnet.additional_public_subnets)

  subnet_id      = aws_subnet.additional_public_subnets[count.index].id
  route_table_id = module.vpc.public_route_table_ids[0]
}

resource "tls_private_key" "bastion" {
  count = var.bastion_host_enabled && var.bastion_host_ssh_public_key == "" ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  count           = var.bastion_host_enabled && var.bastion_host_ssh_public_key == "" ? 1 : 0
  content         = tls_private_key.bastion[0].private_key_pem
  filename        = "${var.name}-private-key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "bastion" {
  count = var.bastion_host_enabled ? 1 : 0

  key_name   = local.bastion_host_key_pair_name
  public_key = var.bastion_host_ssh_public_key != "" ? var.bastion_host_ssh_public_key : tls_private_key.bastion[0].public_key_openssh
}

module "bastion" {
  count = var.bastion_host_enabled ? 1 : 0

  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.31.0"

  ami_filter                  = { name = [var.bastion_host_ami_name_filter] }
  ami_owners                  = var.bastion_host_ami_owners
  ami                         = var.bastion_host_ami_id
  associate_public_ip_address = var.bastion_host_assign_public_ip
  enabled                     = var.bastion_host_enabled
  instance_type               = var.bastion_host_instance_type
  instance_profile            = var.bastion_host_enabled ? var.bastion_instance_profile : null
  key_name                    = aws_key_pair.bastion[0].key_name
  name                        = "${var.name}-bastion"
  security_groups             = var.bastion_host_extra_security_groups
  security_group_rules        = concat(local.bastion_host_security_group_rules, var.bastion_host_security_group_rules)
  ssm_enabled                 = true
  subnets                     = var.bastion_host_assign_public_ip ? module.vpc.public_subnets : module.vpc.private_subnets
  tags                        = var.tags
  vpc_id                      = module.vpc.vpc_id
  user_data                   = var.bastion_host_user_data
  user_data_base64            = var.bastion_host_user_data_base64
}
