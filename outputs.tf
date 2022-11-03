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

output "additional_private_subnet_ids" {
  description = "The IDs of the additional private subnets that have been created."
  value = [
    for k, v in aws_subnet.additional_private_subnets : v.id
  ]
}

output "additional_public_subnet_ids" {
  description = "The IDs of the additional public subnets that have been created."
  value = [
    for k, v in aws_subnet.additional_public_subnets : v.id
  ]
}

output "bastion_host_private_ip" {
  value = join("", module.bastion[*].private_ip)
}

output "bastion_host_public_ip" {
  value = join("", module.bastion[*].public_ip)
}

output "bastion_host_security_group_id" {
  value = join("", module.bastion[*].security_group_id)
}

output "bastion_host_ssh_user" {
  value = join("", module.bastion[*].ssh_user)
}

output "id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "The IDs of the main private subnets that have been created."
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "The IDs of the main public subnets that have been created."
  value       = module.vpc.public_subnets
}
