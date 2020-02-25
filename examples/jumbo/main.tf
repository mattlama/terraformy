provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# This example will go over the entire list of possible variables to set with their defaults

# Example create new Parameters
module "terraformy_new" {
    source     = "../../../terraformy"
    app_name   = var.app_name # Required. This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories
    aws_region = var.aws_region # Required if creating a new ECS cluster. This is the region the ECS cluster will live in
    #Tags
    owners   = [] # This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided
    projects = [] # This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided

#     #VPC
#     existing_vpcs        = []  # If the user wants to put their new components into an existing VPC they may do so. This is an array of VPC ids but will only use the first value
#     cidr_block           = "0.0.0.0/16" # Required if creating new VPC
#     availability_zones   = [] # Required if creating new VPC. These are the availability zones associated with the VPC
#     private_subnets      = [] # Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block
#     public_subnets       = [] # Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block
#     enable_dns_hostnames = true
#     enable_nat_gateway   = true
#     enable_vpn_gateway   = false
#     single_nat_gateway   = false
#     reuse_nat_ips        = true # <= Skip creation of EIPs for the NAT Gateways

#     #Security
#     existing_security_group = [] # Leave blank to create a new security group. Otherwise it will use the VPC id to find an associated security group
#     ingress_rules           = ["https-443-tcp", "http-80-tcp", "http-8080-tcp"] # Required when creating new security groups
#     ingress_cidr_blocks     = ["0.0.0.0/0"] # Required when creating new security groups
#     egress_rules            = ["https-443-tcp", "http-80-tcp", "http-8080-tcp", "mssql-tcp"] # Required when creating new security groups
#     egress_cidr_blocks      = ["0.0.0.0/0"] # Required when creating new security groups

#     #ECS-EC2
#     ecs_type           = [] # Assign a value here and the script will generate an ecs ec2 container for each element added. Values should be 'FARGATE' or 'EC2'   
#     app_port           = 8080 # Required if creating a new ECS cluster. This is the port traffic for this ecs cluster will use
#     secure_port        = 443 # port used for secure connections  
#     provisioned_memory = "2048" # Instance memory to provision (in MiB)
#     environments       = ["dev", "qa", "prod"] # The environments we want to create for our ecs service
#     container_count    = 3 # Number of containers to run
#     # TODO Create a new key pair as needed rather than require existing key pair to get passed in
#     key_pair                  = "" # The AWS key pair we will be using
#     instance_root_volume_size = 20 # Root volume size
#     asg_max_size              = 4 # Maximum number EC2 instances
#     asg_min_size              = 2 # Minimum number of instances
#     asg_desired_size          = 2 # Desired number of instances
#     instance_type             = "t2.medium" # The EC2 instance type which will be used in our cluster. Default is t2.medium

#     #IAM Roles
#     # Default instance policy document
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
#     ecs_existing_iam_role = [] # Use an existing AWS IAM role for the ECS Cluster rather than create a new one. Pass in the arn of the existing AWS IAM role here
#     ec2_existing_iam_role = [] # Use an existing AWS IAM role for the EC2 Instances rather than create a new one. Pass in the name of the existing AWS IAM role here
#     network_mode          = "awsvpc" # The network type the task definition will use

#     # ASG
#     asg_existing_ecs      = [] # Use an existing ECS cluster rather than a newly created ASG. Pass in the name of the existing ECS cluster here
#     asg_existing_iam_role = [] # Use an existing AWS IAM role for the ASG rather than create a new one. Pass in the arn of the existing AWS IAM role here

#     #Parameter Store
#     # NOTE Must have values for same parameter in same order for all 4 fields
#     parameter_store_names         = [] # The Parameter Store Parameters we will be creating
#     parameter_store_descriptions  = [] # The Parameter Store Parameters we will be creating
#     parameter_store_types         = [] # The Parameter Store Parameters we will be creating
#     parameter_store_values        = [] # The Parameter Store Parameters we will be creating
#     existing_parameter_store_name = [] # Existing Parameter Store Parameter name. Will attempt to return its value
#     parameters                    = [] # Takes a slice of maps with name, description, type, and value fields

#     #S3 
#     existing_s3_bucket  = [] # Existing S3 bucket name
#     create_s3_bucket    = false # Whether or not to create an s3 bucket. Will not create a new S3 bucket if existing_s3_bucket is also set
#     existing_s3_object  = [] # Existing S3 object
#     s3_object_keys      = [] # Object keys for the objects we want to create. Must match s3_object_locations
#     s3_object_locations = [] # locations of the files we want to create in s3. Must match s3_object_keys
#     s3_objects          = [] # Map of the objects which need to be created. Set 'bucket' to an empty string to use the bucket coming out of the s3 module

#     #lambda
#     # Default instance policy document
#     lambda_role_policy = <<EOF
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
#     # Default custom lambda policy
#     lambda_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents",
#         "ssm:GetParameters",
#         "ssm:GetParametersByPath",
#         "ec2:DescribeInstances",
#         "ec2:CreateNetworkInterface",
#         "ec2:DeleteNetworkInterface",
#         "ec2:AttachNetworkInterface",
#         "ec2:DescribeNetworkInterfaces",
#         "kms:Decrypt"
#       ],
#       "Resource": "*",
#       "Effect": "Allow"
#     }
#   ]
# }
# EOF
#     lambda_cloudwatch_logging_retention_in_days = 14 # How long to retain cloudwatch logs
#     alias_name                = ["live"] # Name for an alias for our lambda function
#     alias_function_version    = ["1"] # The version we want our function alias to use
#     schedule_expression       = "rate(1 minute)" # The schedule expression used in our cloudwatch event rule
#     lambda_timeout            = 20 # The timeout for the lambda function
#     handler                   = "main" # The handler our lambda will use
#     lambda_runtime            = "go1.x" # The runtime environment for our lambda
#     lambda_s3_key             = "" # The key of the build file for our lambda expression in s3
#     lambda_cloudwatch_logging = false # When true will create cloudwatch logging for our lambda function
#     create_lambda             = false # When true will create a lambda function
#     existing_lambda           = [] # If we want to add cloudwatch logging to an existing lambda functino rather than creating a new one give the function arn here
#     existing_lambda_role      = [] # If we have an existing iam role we want to use for our lambda function pass in the role policy here
#     lambda_s3_bucket          = [] # The bucket name of an existing bucket. Used in the case where we are not creating a new S3 bucket and do not want to reference one outside of lambda generation

#     #ALB
#     create_alb               = false # This will create an alb when toggled true
#     alb_logging_enabled      = false # Toggle true to enable default logging for the alb
#     alb_ssl_policy           = "ELBSecurityPolicy-2016-08" # The ssl policy our alb will be using
#     alb_listener_protocol    = "HTTPS" # The protocol the alb listener will use
#     existing_certificate_arn = [""] # Use an existing data certificate
#     domain                   = "" # The domain used in creation of the alb listener rules. used in the format environment-app_name-domain

#     #Route53
#     create_route53          = false # toggle true to create route53 entries for each environment
#     existing_private_zone   = false # Whether or not the existing zone is private or not
#     route53_record_type     = "A" # The type of route53 we want to create
#     evaluate_target_health  = true # Whether or not to track target health

#     #IAM-User
#     # The policy which will be used when a user is created and asks for an 'ECS' policy
#     default_user_ecs_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": "*",
#             "Resource": "*"
#         }
#     ]
# }
# EOF
#     default_user_ecr_policy = "" # The policy which will be used when a user is created and asks for an 'ECS' policy and needs ECR access
#     create_iam_user         = false # toggle this to true if you want an iam user created
#     iam_users               = [] # a slice of maps which will contain the fields 'name' and 'policies' where policies is a slice which values can currently can be 'ECR' or 'ECS'. Will only be used when create_iam_user is true
}
