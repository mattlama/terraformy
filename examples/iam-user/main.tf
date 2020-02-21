provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Example use existing vpc and security group with a new ecs ec2 cluster
module "terraformy_new" {
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

    existing_security_group = [var.existing_security_group_id] # Note it will use whatever security group if provided/created

    #ECS
    ecs_container   = ["EC2"] 

    #IAM User
    create_iam_user = true # Will create an iam user called app_name-devops which will have access to the ecs cluster created and the ecr repo created

    # If we want to create a new user with no policies attached we can do so like this:
    # iam_users = [{"name" = "NewName", "policies" = []}]
}
