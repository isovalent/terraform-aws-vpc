locals {
  bastion_host_key_pair_name = "${var.name}-bastion"
  availability_zones         = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.available.names
}
