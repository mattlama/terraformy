# For now we are limiting the number of Security Groups created at a time to 1 per jumbo

# Refer here for documentation
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.1.0

module "security_group" {
  create  = length(var.existing_security_group) == 0 ? true: false
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"
  # insert the 2 required variables here
  name                = "${var.app_name}_SecurityGroup"
  vpc_id              = var.vpc_id
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["https-443-tcp", "http-80-tcp", "http-8080-tcp", "mssql-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]

  //vpc_id  = data.aws_vpc.selected.id
  tags = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
    Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
  }
}

data "aws_security_group" "existing" {
    count = length(var.existing_security_group) > 0 ? 1: 0
    vpc_id = var.vpc_id
}
