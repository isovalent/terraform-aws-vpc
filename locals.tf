locals {
  bastion_host_key_pair_name = "${var.name}-bastion"
  availability_zones         = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.available.names
  bastion_host_security_group_rules = [
    {
      "cidr_blocks" : ["0.0.0.0/0"],
      "description" : "Allow all outbound traffic",
      "from_port" : 0,
      "protocol" : -1,
      "to_port" : 0,
      "type" : "egress"
    },
    {
      "cidr_blocks" : var.access_ip_addresses,
      "description" : "Allow all inbound to SSH",
      "from_port" : 22,
      "protocol" : "tcp",
      "to_port" : 22,
      "type" : "ingress"
    }
  ]
}
