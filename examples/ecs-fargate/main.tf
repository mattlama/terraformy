provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Example use existing vpc and security group with a new ecs ec2 cluster
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

    existing_security_group = [var.existing_security_group_id] # Note it will use whatever security group if provided/created

    #ECS
    ecs_type  = ["FARGATE"] # Choices are EC2 or FARGATE. Leave blank if no ECS cluster is desired
    create_alb     = true # NOTE Currently the FARGATE cluster is tied to the alb so we must set this to true for now
    create_route53 = true # If we are creating an alb already we might as well create route53 entries for it as well
    domain         = var.domain # Need to know what domain to associate the routes with
    # Set existing_private_zone to true if the route53 zone our domain is hosted at is private
    
    #There are many values used by the ECS which can be set
#     app_port                  = 8080
#     secure_port               = 443
#     provisioned_memory        = "2048"
#     environments              = ["dev", "qa", "prod"] # NOTE environments here get used for the environments in all components which need an environment
#     container_count           = 3
#     key_pair                  = ""
#     instance_root_volume_size = 20
#     asg_max_size              = 4 
#     asg_min_size              = 2
#     asg_desired_size          = 2
#     instance_type             = "t2.medium"
# #IAM
#     instance_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
#     ecs_existing_iam_role = []
#     ec2_existing_iam_role = []
}

# Creating a new ECS EC2 cluster will create the following:
# At present we create an autoscaling group when an EC2 cluster is created
# autoscaling policy down (1 for each environment)
# autoscaling policy up (1 for each environment)
# autoscaling target (1 for each environment)
# cloudwatch alarm high cpu (1 for each environment)
# cloudwatch alarm low cpu (1 for each environment)
# iam role autoscaling (1)
# iam role autoscaling policy attachment (1)
# iam role instance (1)
# iam role instance policy attachment (1)
# autoscaling group (1)
# ecr repository (1)
# ecs cluster (1)
# ecs service (1 for each environment)
# task definition (1)
# iam instance profile (1)
# instance launch configuration (1)
# iam role task (1)
# iam role task policy attachment (1)
# For a total of 3 + 3 + 3 + 3 + 3 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 3 + 1 + 1 + 1 + 1 + 1 = 30 components created in our example
