provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Use existing VPC
module "terraformy_existing" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-old"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    # If using existing VPC only set this:
    existing_vpcs = [var.existing_vpc_id]

    # Note by default security group will attempt to get created. To prevent this add a blank id to existing security group
    existing_security_group = [""]
}

# Example create new VPC
module "terraformy_new" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-new"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    # If using existing VPC only set this:
    # existing_vpcs = [var.existing_vpc_id]
    # If creating a new VPC Set the following:
    # Required if creating new VPC
    cidr_block         = "123.45.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"] # For each availability zone we need a subnet range for public and private
    private_subnets    = ["123.45.1.0/24", "123.45.2.0/24", "123.45.3.0/24"]
    public_subnets     = ["123.45.101.0/24", "123.45.102.0/24", "123.45.103.0/24"]
    # Optional
    # enable_dns_hostnames
    # enable_nat_gateway
    # enable_vpn_gateway
    # single_nat_gateway
    # reuse_nat_ips

    # Note by default security group will attempt to get created. To prevent this add a blank id to existing security group
    existing_security_group = [""]
}

# Creating a new VPC will create the following:
# VPC (1 at the moment)
# public subnets (1 for each availability zone)
# private subnets (1 for each availability zone)
# public route table (1)
# private route table (1 for each availability zone)
# route table association (1 for each subnet)
# public route (1)
# private route (1 for each availability zone)
# elastic ip (1 for public + 1 for each availability zone)
# internet gateway (1)
# nat gateway (1 for each availability zone)
# For a total of 1 + 3 + 3 + 1 + 3 + 6 + 1 + 3 + 4 + 1 + 3 = 29 components created in our example
