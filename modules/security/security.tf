# For now we are limiting the number of Security Groups created at a time to 1 per jumbo

# Refer here for documentation
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.1.0

module "security_group" {
  create  = length(var.existing_security_group) == 0 ? (length(var.security_groups_to_create) > 0 ? true: false): false
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"
  # for_each support is coming for modules. Will replace _count with count.index
  name                = length(var.security_groups_to_create) > 0 ? "${var.app_name}_SecurityGroup_X" : "${var.app_name}_SecurityGroup"
  vpc_id              = var.vpc_id
  ingress_rules       = lookup(var.security_groups_to_create[0], "ingress_rules", "unable to find ingress rules")
  ingress_cidr_blocks = lookup(var.security_groups_to_create[0], "ingress_cidr_blocks", "unable to find ingress cidr blocks")
  egress_rules        = lookup(var.security_groups_to_create[0], "egress_rules", "unable to find egress rules")
  egress_cidr_blocks  = lookup(var.security_groups_to_create[0], "egress_cidr_blocks", "unable to find egress cidr blocks")

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
