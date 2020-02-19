# For now we are limiting the number of VPCs created at a time to 1 per jumbo as the purpose is to package all the jumbo components together

# New VPC
# Refer here for documentation
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.9.0
resource "aws_eip" "nat" {
  count = length(var.existing_vpcs) == 0 ? (length(var.availability_zones) + 1): 0

  vpc = true
}

# Create a new VPC which is managed by terraform
module "vpc" {
  create_vpc      = length(var.existing_vpcs) == 0 ? true: false
  source          = "terraform-aws-modules/vpc/aws"
  version         = "2.9.0"
  name            = "${var.app_name}_VPC"
  cidr            = var.cidr_block 
  azs             = var.availability_zones 
  private_subnets = var.private_subnets 
  public_subnets  = var.public_subnets 

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_nat_gateway   = var.enable_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
  single_nat_gateway   = var.single_nat_gateway
  reuse_nat_ips        = var.reuse_nat_ips 

  external_nat_ip_ids = aws_eip.nat.*.id # <= IPs specified here as input to the module

  tags = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
    Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
  }
}

# Existing VPC
data "aws_vpc" "existing" {
    count = length(var.existing_vpcs) > 0 ? 1: 0
    id    = var.existing_vpcs[0]
}

data "aws_subnet_ids" "public" {
  count = length(var.existing_vpcs)
  vpc_id = data.aws_vpc.existing[0].id
  filter {
    name = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_subnet_ids" "private" {
  count = length(var.existing_vpcs)
  vpc_id = data.aws_vpc.existing[0].id
  filter {
    name = "tag:Name"
    values = ["*private*"]
  }
}
