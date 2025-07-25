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

variable "availability_zones" {
  # Usage: -var 'availability_zones=["us-east-1a"]'
  description = <<-EOT
    List of availability zone names that subnets can get deployed into.
      If not provided, defaults to all AZs for the region.
  EOT
  type        = list(string)
  default     = []
}

variable "additional_private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "additional_public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "additional_private_subnets" {
  default     = []
  description = "Additional private subnets to create."
  type = list(object({
    availability_zone = string
    cidr              = string
    tags              = map(string)
  }))
}

variable "additional_public_subnets" {
  default     = []
  description = "Additional public subnets to create."
  type = list(object({
    availability_zone = string
    cidr              = string
    tags              = map(string)
  }))
}

variable "bastion_host_ami_name_filter" {
  description = "The AMI filter to use for the bastion host's AMI."
  type        = string
  default     = "amzn2-ami-hvm-2.*-x86_64-ebs"

}

variable "bastion_host_ami_owners" {
  description = "The list of owners used to select the AMI."
  type        = list(string)
  default     = ["amazon"]
}

variable "bastion_host_ami_id" {
  type        = string
  description = "The ID of the AIM to use for the instance. Setting this will ignore `bastion_host_ami_name_filter` and `bastion_host_ami_owners`."
  default     = null
}

variable "bastion_host_assign_public_ip" {
  default     = false
  description = "Whether to assign a public IP address to the bastion host."
  type        = bool
}

variable "bastion_host_enabled" {
  default     = false
  description = "Whether to create an EC2 instance in the VPC that can be used as a bastion host."
  type        = bool
}

variable "bastion_host_extra_security_groups" {
  default     = []
  description = "A list of extra security groups to associate with the bastion host."
  type        = list(string)
}

variable "bastion_host_security_group_rules" {
  default     = []
  description = "A list of security group rules to apply to the bastion host."
  type        = list(any)
}

variable "access_ip_addresses" {
  default     = []
  description = "The list of IP address specified will be able to access the bastion."
  type        = list(string)
  validation {
    condition     = !var.bastion_host_enabled || length(var.access_ip_addresses) > 0
    error_message = "At least one IP address must be specified when bastion host is enabled."
  }
}

variable "bastion_host_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The instance type to use for the bastion host."
}

variable "bastion_host_ssh_public_key" {
  default     = ""
  description = "If specified, will be used as the public SSH key for the bastion host."
  type        = string
}

variable "bastion_instance_profile" {
  default     = ""
  description = "A pre-defined profile to attach to the instance"
  type        = string
}
variable "bastion_host_user_data" {
  default     = []
  description = "The user data to use for the bastion host."
  type        = list(string)
}

variable "bastion_host_user_data_base64" {
  default     = ""
  description = "The user data to use for the bastion host, base64 encoded."
  type        = string
}

variable "cidr" {
  description = "The CIDR to be used for the VPC."
  type        = string
}

variable "name" {
  description = "The name of the VPC."
  type        = string
}

variable "region" {
  description = "The region in which to create the VPC."
  type        = string
}

variable "secondary_cidr_blocks" {
  default     = []
  description = "List of secondary CIDR blocks to use."
  type        = list(string)
}

variable "tags" {
  description = "The tags to place on the VPC."
  type        = map(string)
}

variable "enable_ipv6" {
  default     = false
  description = "Whether to enable the ipv6 stack."
  type        = bool
}

variable "map_public_ip_on_launch" {
  default     = false
  description = "Whether to map public IPs on launch."
  type        = bool
}
