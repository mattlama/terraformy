variable "app_name" {
  description = "Required. This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories"
  # Rules about app name. ECR repository has a limit of 32 characters and must be all lower case. ALB requires no underscores.
  # Ideally the name is less than 20 characters, all lowercase, and no underscores
}

variable "existing_vpcs" {
  description = "If the user wants to put their new components into an existing VPC they may do so. This is an array of VPC ids but will only use the first value"
  default     = []
}

#Tags
variable "owners" {
  description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
  default     = []
}

variable "projects" {
  description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
  default     = []
}

#VPC
variable "cidr_block" {
  description = "Required if creating new VPC"
  default     = "0.0.0.0/16"
}

variable "availability_zones" {
  description = "Required if creating new VPC. These are the availability zones associated with the VPC"
  default     = []
}

variable "private_subnets" {
  description = "Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block"
  default     = []
}

variable "public_subnets" {
  description = "Required if creating new VPC. We need one set of subnets for each availability_zone and they must fall within the CIDR block"
  default     = []
}

variable "enable_dns_hostnames" {
  description = ""
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = ""
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = ""
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = ""
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = ""
  type        = bool
  default     = true # <= Skip creation of EIPs for the NAT Gateways
}

#Security
variable "existing_security_group" {
  description = "Leave blank to create a new security group. Otherwise it will use the VPC id to find an associated security group"
  default     = []
}

variable "ingress_rules" {
  description = "Required when creating new security groups"
  default     = ["https-443-tcp", "http-80-tcp", "http-8080-tcp"]
}

variable "ingress_cidr_blocks" {
  description = "Required when creating new security groups"
  default     = ["0.0.0.0/0"]
}

variable "egress_rules" {
  description = "Required when creating new security groups"
  default     = ["https-443-tcp", "http-80-tcp", "http-8080-tcp", "mssql-tcp"]
}

variable "egress_cidr_blocks" {
  description = "Required when creating new security groups"
  default     = ["0.0.0.0/0"]
}

variable "security_group_rules_to_create" {
  description = "A slice of maps which contains the fields 'ingress_rules' and 'egress_rules'. Both of which are maps which contain the fields 'port', and 'cidr_blocks'"
  # NOTE port gets mapped to from_port and to_port so this currently cannot accept a range of ports
  default     = [
  {
    "ingress_rules" = [{
      "port" = 80,
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    {
      "port" = 8080,
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    {
      "port" = 443,
      "cidr_blocks" = ["0.0.0.0/0"]
    }],
    "egress_rules" = [{
      "port" = 80,
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    {
      "port" = 8080,
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    {
      "port" = 443,
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    {
      "port" = 1433,
      "cidr_blocks" = ["0.0.0.0/0"]
    }]
  }]
}

#ECS-EC2
variable "ecs_type" {
  description = "Assign a value here and the script will generate an ecs cluster for each element added. Values should be 'FARGATE' or 'EC2'"
  default     = []
}

variable "app_port" {
  description = "Required if creating a new ECS cluster. This is the port traffic for this ecs cluster will use"
  default     = 8080
}

variable "secure_port" {
  description = "port used for secure connections"
  default     = 443
}

variable "aws_region" {
  description = "Required if creating a new ECS cluster. This is the region the ECS cluster will live in"
}

variable "provisioned_memory" {
  description = "Instance memory to provision (in MiB)"
  default     = "2048"
}

variable "environments" {
  description = "The environments we want to create for our ecs service"
  default     = ["dev", "qa", "prod"]
}

variable "container_count" {
  description = "Number of containers to run"
  default     = 3
}

# TODO Create a new key pair as needed rather than require existing key pair to get passed in
variable "key_pair" {
  description = "The AWS key pair we will be using"
  default     = ""
}

variable "instance_root_volume_size" {
  description = "Root volume size"
  default     = 20
}

variable "asg_max_size" {
  description = "Maximum number EC2 instances"
  default     = 4 
}

variable "asg_min_size" {
  description = "Minimum number of instances"
  default     = 2
}

variable "asg_desired_size" {
  description = "Desired number of instances"
  default     = 2
}

variable "instance_type" {
  description = "The EC2 instance type which will be used in our cluster. Default is t2.medium"
  default     = "t2.medium"
}

#IAM Roles
variable "instance_policy" {
  description = "Default instance policy document"
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

variable "ecs_existing_iam_role" {
  description = "Use an existing AWS IAM role for the ECS Cluster rather than create a new one. Pass in the arn of the existing AWS IAM role here" 
  default     = []
}

variable "ec2_existing_iam_role" {
  description = "Use an existing AWS IAM role for the EC2 Instances rather than create a new one. Pass in the name of the existing AWS IAM role here" 
  default     = []
}

# variable "network_mode" {
#   description = "The network type the task definition will use"
#   default     = "bridge"
# }

variable "ecs_is_web_facing" {
  description = "Whether or not to create alb and route53 entries for the ecs cluster"
  default     = false
}

# ASG
variable "asg_existing_ecs" {
  description = "Use an existing ECS cluster rather than a newly created ASG. Pass in the name of the existing ECS cluster here"
  default     = []
}

variable "asg_existing_iam_role" {
  description = "Use an existing AWS IAM role for the ASG rather than create a new one. Pass in the arn of the existing AWS IAM role here" 
  default     = []
}

#Parameter Store
# NOTE Must have values for same parameter in same order for all 4 fields
variable "parameter_store_names" {
  description = "The Parameter Store Parameters we will be creating"
  default     = []
}

variable "parameter_store_descriptions" {
  description = "The Parameter Store Parameters we will be creating"
  default     = []
}

variable "parameter_store_types" {
  description = "The Parameter Store Parameters we will be creating"
  default     = []
}

variable "parameter_store_values" {
  description = "The Parameter Store Parameters we will be creating"
  default     = []
}

variable "existing_parameter_store_name" {
  description = "Existing Parameter Store Parameter name. Will attempt to return its value"
  default     = []
}

variable "parameters" {
  description = "Takes a slice of maps with name, description, type, and value fields"
  default     = []
}

#S3 
variable "existing_s3_bucket" {
  description = "Existing S3 bucket name"
  default     = []
}

variable "create_s3_bucket" {
  description = "Whether or not to create an s3 bucket. Give it any value. Will not create a new S3 bucket if existing_s3_bucket is also set"
  default     = false
}

variable "existing_s3_object" {
  description = "Existing S3 object"
  default     = []
}

variable "s3_object_keys" {
  description = "Object keys for the objects we want to create. Must match s3_object_locations"
  default     = []
}

variable "s3_object_locations" {
  description = "locations of the files we want to create in s3. Must match s3_object_keys"
  default     = []
}

variable "s3_objects" {
  description = "Map of the objects which need to be created. Set 'bucket' to an empty string to use the bucket coming out of the s3 module"
  default     = []
}

#lambda
variable "lambda_role_policy" {
  description = "Default instance policy document"
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

variable "lambda_policy" {
  description = "Default custom lambda policy"
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ec2:DescribeInstances",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "kms:Decrypt"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

variable "lambda_cloudwatch_logging_retention_in_days" {
  description = "How long to retain cloudwatch logs"
  default     = 14
}

variable "alias_name" {
  description = "Name for an alias for our lambda function"
  default     = ["live"]
}

variable "alias_function_version" {
  description = "The version we want our function alias to use"
  default     = ["1"]
}

variable "schedule_expression" {
  description = "The schedule expression used in our cloudwatch event rule"
  default     = "rate(1 minute)"
}

variable "lambda_timeout" {
  description = "The timeout for the lambda function"
  default     = 20
}

variable "handler" {
  description = "The handler our lambda will use"
  default     = "main"
}

variable "lambda_runtime" {
  description = "The runtime environment for our lambda"
  default     = "go1.x"
}

variable "lambda_s3_key" {
  description = "The key of the build file for our lambda expression in s3"
  default     = ""
}

variable "lambda_cloudwatch_logging" {
  description = "When true will create cloudwatch logging for our lambda function"
  default     = false
}

variable "create_lambda" {
  description = "When true will create a lambda function"
  default     = false
}

variable "existing_lambda" {
  description = "If we want to add cloudwatch logging to an existing lambda functino rather than creating a new one give the function arn here"
  default     = []
}

variable "existing_lambda_role" {
  description = "If we have an existing iam role we want to use for our lambda function pass in the role policy here"
  default     = []
}

variable "lambda_s3_bucket" {
  description = "The bucket name of an existing bucket. Used in the case where we are not creating a new S3 bucket and do not want to reference one outside of lambda generation"
  default     = []
}

#ALB
variable "create_alb" {
  description = "This will create an alb when toggled true"
  default     = false
  type        = bool
}

variable "alb_logging_enabled" {
  description = "Toggle true to enable default logging for the alb"
  default     = false
}

variable "alb_ssl_policy" {
  description = "The ssl policy our alb will be using"
  default     = "ELBSecurityPolicy-2016-08"
}

variable "alb_listener_protocol" {
  description = "The protocol the alb listener will use"
  default     = "HTTPS"
}

variable "existing_certificate_arn" {
  description = "Use an existing data certificate"
  default     = [""]
}

variable "domain" {
  description = "The domain used in creation of the alb listener rules. used in the format environment-app_name-domain"
  default     = ""
}

variable "asg_add_asg_policies" {
  description = "Whether we want to add autoscaling policies for scaling up/down when creating our autoscaling group"
  default     = true
}


#Route53
variable "create_route53" {
  description = "toggle true to create route53 entries for each environment"
  default     = false
}

variable "existing_private_zone" {
  description = "Whether or not the existing zone is private or not"
  type        = bool
  default     = false
}

variable "route53_record_type" {
  description = "The type of route53 we want to create"
  default     = "A"
}

variable "evaluate_target_health" {
  description = "Whether or not to track target health"
  type        = bool
  default     = true
}

#IAM-User
variable "default_user_ecs_policy" {
  description = "The policy which will be used when a user is created and asks for an 'ECS' policy"
  default     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

variable "default_user_ecr_policy" {
  description = "The policy which will be used when a user is created and asks for an 'ECS' policy and needs ECR access"
  default     = ""
}

variable "create_iam_user" {
  description = "toggle this to true if you want an iam user created"
  type        = bool
  default     = false
}

variable "iam_users" {
  description = "a slice of maps which will contain the fields 'name' and 'policies' where policies is a slice which values can currently can be 'ECR' or 'ECS'. Will only be used when create_iam_user is true"
  default     = []
}
