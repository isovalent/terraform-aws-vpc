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
