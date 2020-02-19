provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Example use existing vpc and security group
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

    #Security
    existing_security_group = [var.existing_security_group_id]
}

# Example create new Security group in existing vpc
module "terraformy_new" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-new"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    # We need a VPC to create our security group in
    existing_vpcs = [var.existing_vpc_id] # NOTE it will by default use the vpc here whether new or existing when creating a new security group

    #Security
    # Note by default security group will attempt to get created. To prevent this add a blank id to existing security group
    # The following can be set. Currently they are showing their default values
    # ingress_rules       = ["https-443-tcp", "http-80-tcp", "http-8080-tcp"]
    # ingress_cidr_blocks = ["0.0.0.0/0"]
    # egress_rules        = ["https-443-tcp", "http-80-tcp", "http-8080-tcp", "mssql-tcp"]
    # egress_cidr_blocks  = ["0.0.0.0/0"]
}

# Creating a new Security group will create the following:
# security group (1)
# egress rule (1 for each egress rule provided. Default is 4)
# ingress rule (1 for each ingress rule provided. Default is 3)
# For a total of 1 + 4 + 3 = 8 components created in our example
