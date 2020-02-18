module "jumbo_vpc" {
  source   = "../vpc"
  app_name = var.app_name
  #Tags
  owners   = var.owners
  projects = var.projects
  #VPC
  # If using existing VPC only set this:
  existing_vpcs = var.existing_vpcs
  # If creating a new VPC Set the following:
  # Required if creating new VPC
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  # Optional
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_nat_gateway   = var.enable_nat_gateway
  enable_vpn_gateway   = var.enable_vpn_gateway
  single_nat_gateway   = var.single_nat_gateway
  reuse_nat_ips        = var.reuse_nat_ips
}