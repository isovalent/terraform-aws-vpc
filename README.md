# terraform-aws-vpc

An opinionated Terraform module that can be used to create and manage an VPC in AWS in a simplified way.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.31.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.1.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | < 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | cloudposse/ec2-bastion-server/aws | 0.31.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.15.0 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route_table_association.additional_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.additional_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.additional_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.additional_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.wait_for_secondary_cidrs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.bastion](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_ip_addresses"></a> [access\_ip\_addresses](#input\_access\_ip\_addresses) | The list of IP address specified will be able to access the bastion. | `list(string)` | `[]` | no |
| <a name="input_additional_private_subnet_tags"></a> [additional\_private\_subnet\_tags](#input\_additional\_private\_subnet\_tags) | Additional tags for the private subnets | `map(string)` | `{}` | no |
| <a name="input_additional_private_subnets"></a> [additional\_private\_subnets](#input\_additional\_private\_subnets) | Additional private subnets to create. | <pre>list(object({<br/>    availability_zone = string<br/>    cidr              = string<br/>    tags              = map(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_public_subnet_tags"></a> [additional\_public\_subnet\_tags](#input\_additional\_public\_subnet\_tags) | Additional tags for the public subnets | `map(string)` | `{}` | no |
| <a name="input_additional_public_subnets"></a> [additional\_public\_subnets](#input\_additional\_public\_subnets) | Additional public subnets to create. | <pre>list(object({<br/>    availability_zone = string<br/>    cidr              = string<br/>    tags              = map(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zone names that subnets can get deployed into.<br/>  If not provided, defaults to all AZs for the region. | `list(string)` | `[]` | no |
| <a name="input_bastion_host_ami_id"></a> [bastion\_host\_ami\_id](#input\_bastion\_host\_ami\_id) | The ID of the AIM to use for the instance. Setting this will ignore `bastion_host_ami_name_filter` and `bastion_host_ami_owners`. | `string` | `null` | no |
| <a name="input_bastion_host_ami_name_filter"></a> [bastion\_host\_ami\_name\_filter](#input\_bastion\_host\_ami\_name\_filter) | The AMI filter to use for the bastion host's AMI. | `string` | `"amzn2-ami-hvm-2.*-x86_64-ebs"` | no |
| <a name="input_bastion_host_ami_owners"></a> [bastion\_host\_ami\_owners](#input\_bastion\_host\_ami\_owners) | The list of owners used to select the AMI. | `list(string)` | <pre>[<br/>  "amazon"<br/>]</pre> | no |
| <a name="input_bastion_host_assign_public_ip"></a> [bastion\_host\_assign\_public\_ip](#input\_bastion\_host\_assign\_public\_ip) | Whether to assign a public IP address to the bastion host. | `bool` | `false` | no |
| <a name="input_bastion_host_enabled"></a> [bastion\_host\_enabled](#input\_bastion\_host\_enabled) | Whether to create an EC2 instance in the VPC that can be used as a bastion host. | `bool` | `false` | no |
| <a name="input_bastion_host_extra_security_groups"></a> [bastion\_host\_extra\_security\_groups](#input\_bastion\_host\_extra\_security\_groups) | A list of extra security groups to associate with the bastion host. | `list(string)` | `[]` | no |
| <a name="input_bastion_host_instance_type"></a> [bastion\_host\_instance\_type](#input\_bastion\_host\_instance\_type) | The instance type to use for the bastion host. | `string` | `"t2.micro"` | no |
| <a name="input_bastion_host_security_group_rules"></a> [bastion\_host\_security\_group\_rules](#input\_bastion\_host\_security\_group\_rules) | A list of security group rules to apply to the bastion host. | `list(any)` | `[]` | no |
| <a name="input_bastion_host_ssh_public_key"></a> [bastion\_host\_ssh\_public\_key](#input\_bastion\_host\_ssh\_public\_key) | If specified, will be used as the public SSH key for the bastion host. | `string` | `""` | no |
| <a name="input_bastion_host_user_data"></a> [bastion\_host\_user\_data](#input\_bastion\_host\_user\_data) | The user data to use for the bastion host. | `list(string)` | `[]` | no |
| <a name="input_bastion_host_user_data_base64"></a> [bastion\_host\_user\_data\_base64](#input\_bastion\_host\_user\_data\_base64) | The user data to use for the bastion host, base64 encoded. | `string` | `""` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR to be used for the VPC. | `string` | n/a | yes |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Whether to enable the ipv6 stack. | `bool` | `false` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Whether to map public IPs on launch. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the VPC. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region in which to create the VPC. | `string` | n/a | yes |
| <a name="input_secondary_cidr_blocks"></a> [secondary\_cidr\_blocks](#input\_secondary\_cidr\_blocks) | List of secondary CIDR blocks to use. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to place on the VPC. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_private_subnet_ids"></a> [additional\_private\_subnet\_ids](#output\_additional\_private\_subnet\_ids) | The IDs of the additional private subnets that have been created. |
| <a name="output_additional_private_subnets_cidr_blocks"></a> [additional\_private\_subnets\_cidr\_blocks](#output\_additional\_private\_subnets\_cidr\_blocks) | The additional private subnets that have been created. |
| <a name="output_additional_public_subnet_ids"></a> [additional\_public\_subnet\_ids](#output\_additional\_public\_subnet\_ids) | The IDs of the additional public subnets that have been created. |
| <a name="output_bastion_host_key_pair_name"></a> [bastion\_host\_key\_pair\_name](#output\_bastion\_host\_key\_pair\_name) | The name of the SSH key pair associated with the bastion host. |
| <a name="output_bastion_host_private_ip"></a> [bastion\_host\_private\_ip](#output\_bastion\_host\_private\_ip) | n/a |
| <a name="output_bastion_host_public_ip"></a> [bastion\_host\_public\_ip](#output\_bastion\_host\_public\_ip) | n/a |
| <a name="output_bastion_host_security_group_id"></a> [bastion\_host\_security\_group\_id](#output\_bastion\_host\_security\_group\_id) | n/a |
| <a name="output_bastion_host_ssh_user"></a> [bastion\_host\_ssh\_user](#output\_bastion\_host\_ssh\_user) | n/a |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC. |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | The IDs of the private route table that have been created. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the main private subnets that have been created. |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | The IDs of the public route table that have been created. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the main public subnets that have been created. |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The IPv4 CIDR block that have been used. |
| <a name="output_vpc_ipv6_cidr_block"></a> [vpc\_ipv6\_cidr\_block](#output\_vpc\_ipv6\_cidr\_block) | The IPv6 CIDR block that have been used. |
| <a name="output_vpn_gw_id"></a> [vpn\_gw\_id](#output\_vpn\_gw\_id) | The ID of the VPN gateway that has been created. |
<!-- END_TF_DOCS -->

## License

Copyright 2022 Isovalent, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
