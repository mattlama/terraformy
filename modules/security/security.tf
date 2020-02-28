# For now we are limiting the number of Security Groups created at a time to 1

# Refer here for documentation
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.1.0

# module "security_group" {
#   create  = length(var.existing_security_group) == 0 ? (length(var.security_groups_to_create) > 0 ? true: false): false
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "3.1.0"
#   # for_each support is coming for modules. Will replace _count with count.index
#   name                = length(var.security_groups_to_create) > 0 ? "${var.app_name}_SecurityGroup_X" : "${var.app_name}_SecurityGroup"
#   vpc_id              = var.vpc_id
#   ingress_rules       = length(var.security_groups_to_create) > 0 ? (lookup(var.security_groups_to_create[0], "ingress_rules", [])) : []
#   ingress_cidr_blocks = length(var.security_groups_to_create) > 0 ? (lookup(var.security_groups_to_create[0], "ingress_cidr_blocks", [])) : []
#   egress_rules        = length(var.security_groups_to_create) > 0 ? (lookup(var.security_groups_to_create[0], "egress_rules", [])) : []
#   egress_cidr_blocks  = length(var.security_groups_to_create) > 0 ? (lookup(var.security_groups_to_create[0], "egress_cidr_blocks", [])) : []

#   tags = {
#     Terraform   = "true"
#     Application = var.app_name
#     Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
#     Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
#   }
# }

resource "aws_security_group" "current" {
  count        = length(var.existing_security_group) == 0 ? length(var.security_groups_to_create): 0
  name_prefix  = length(var.security_groups_to_create) > 1 ? "${var.app_name}_SecurityGroup_${count.index}" : "${var.app_name}_SecurityGroup"
  vpc_id       = var.vpc_id
  description  = "Security Group managed by Terraform"
  revoke_rules_on_delete = false

  dynamic "ingress" {
    for_each = lookup(var.security_groups_to_create[count.index], "ingress_rules", [])
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = "tcp"
      cidr_blocks = ingress.value["cidr_blocks"]
      description = ingress.value["port"] == 443 ? "HTTPS": (ingress.value["port"] == 1433 ? "MSSQL Server" : "HTTP" )
    }
  }

  dynamic "egress" {
    for_each = lookup(var.security_groups_to_create[count.index], "egress_rules", [])
    content {
      from_port   = egress.value["port"]
      to_port     = egress.value["port"]
      protocol    = "tcp"
      cidr_blocks = egress.value["cidr_blocks"]
      description = egress.value["port"] == 443 ? "HTTPS": (egress.value["port"] == 1433 ? "MSSQL Server" : "HTTP" )
    }
  }

  tags = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
    Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
  }
}

data "aws_security_group" "existing" {
    count = length(var.existing_security_group) > 0 ? (var.existing_security_group[0] != "" ? 1 : 0): 0
    id    = var.existing_security_group[0]
}
