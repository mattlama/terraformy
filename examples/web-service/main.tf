provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Example web service creating new VPC, Security Group, ECS Cluster, ALB, and Route53 entries
module "terraformy_web_service" {
    source     = "../../../terraformy"
    app_name   = "${var.app_name}-terraformy"
    aws_region = var.aws_region
    #Tags
    owners   = ["Test"]
    projects = ["Test-Project"]

    #VPC
    # Required if creating new VPC
    cidr_block         = "123.45.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"] # For each availability zone we need a subnet range for public and private
    private_subnets    = ["123.45.1.0/24", "123.45.2.0/24", "123.45.3.0/24"]
    public_subnets     = ["123.45.101.0/24", "123.45.102.0/24", "123.45.103.0/24"]

    #Security
    # Gets created by default

    #ECS
    ecs_type          = ["FARGATE"] # Choices are EC2 or FARGATE. Leave blank if no ECS cluster is desired
    ecs_is_web_facing = true
    domain            = var.domain # Need to know what domain to associate the routes with. Currently terraformy cannot create an aws domain
    # Set existing_private_zone to true if the route53 zone our domain is hosted at is private

}

# This will create the following AWS Components
# alb listener (1)
# alb listener rule (1 for each environment)
# autoscaling policy down (1 for each environment)
# autoscaling policy up (1 for each environment)
# autoscaling target (1 for each environment)
# cloudwatch alarm cpu high (1 for each environment)
# cloudwatch alarm cpu low (1 for each environment)
# iam autoscaling role (1)
# iam role attachment (1)
# ecr repository (1)
# ecs cluster (1)
# ecs service (1 for each environment)
# ecs task definition (1)
# iam task execution role (1)
# iam role attachment (1)
# route53 record (1 for each environment)
# eip (1 for each availability_zone + 1)
# load balancer (1)
# load balancer target group (1 for each environment)
# security group (1)
# security group rule egress (1 for each egress rule supplied)
# security group rule ingress (1 for each ingress rule supplied)
# internet gateway (1)
# nat gateway (1 for each availability zone)
# aws route private nat gateway (1 for each availability zone)
# aws route public internet gateway (1)
# aws route table private (1 for each availability zone)
# aws route table public (1)
# aws route table association private (1 for each availability_zone)
# aws route table association public (1 for each availability_zone)
# aws subnet private (1 for each availability_zone)
# aws subnet public (1 for each availability_zone)
# vpc (1)
# For a total of 73 components added
