# terraform-aws-vpc

An opinionated Terraform module that can be used to create and manage an VPC in AWS in a simplified way.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.31.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.14.4 |

## Resources

| Name | Type |
|------|------|
| [aws_route_table_association.additional_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.additional_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.additional_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.additional_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [null_resource.wait_for_secondary_cidrs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_private_subnet_tags"></a> [additional\_private\_subnet\_tags](#input\_additional\_private\_subnet\_tags) | Additional tags for the private subnets | `map(string)` | `{}` | no |
| <a name="input_additional_private_subnets"></a> [additional\_private\_subnets](#input\_additional\_private\_subnets) | Additional private subnets to create. | <pre>list(object({<br>    availability_zone = string<br>    cidr              = string<br>    tags              = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_additional_public_subnet_tags"></a> [additional\_public\_subnet\_tags](#input\_additional\_public\_subnet\_tags) | Additional tags for the public subnets | `map(string)` | `{}` | no |
| <a name="input_additional_public_subnets"></a> [additional\_public\_subnets](#input\_additional\_public\_subnets) | Additional public subnets to create. | <pre>list(object({<br>    availability_zone = string<br>    cidr              = string<br>    tags              = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR to be used for the VPC. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VPC. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region in which to create the VPC. | `string` | n/a | yes |
| <a name="input_secondary_cidr_blocks"></a> [secondary\_cidr\_blocks](#input\_secondary\_cidr\_blocks) | List of secondary CIDR blocks to use. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to place on the VPC. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_private_subnet_ids"></a> [additional\_private\_subnet\_ids](#output\_additional\_private\_subnet\_ids) | The IDs of the additional private subnets that have been created. |
| <a name="output_additional_public_subnet_ids"></a> [additional\_public\_subnet\_ids](#output\_additional\_public\_subnet\_ids) | The IDs of the additional public subnets that have been created. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the main private subnets that have been created. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the main public subnets that have been created. |
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
