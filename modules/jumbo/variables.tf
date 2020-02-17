#Jumbo
variable "app_name" {
  description = "Required. This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories"
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
#TODO Expand to directly take a security group ID. This currently assumes you know the VPC and you know a security group exists but do not have the id at hand
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

#ECS-EC2
variable "ecs_ec2_container" {
  description = "Assign a value here and the script will generate an ecs ec2 container for each element added. Values should be 'FARGATE' or 'EC2'"
  default     = []
}

variable "app_port" {
  description = "Required if creating a new ECS cluster. This is the port traffic for this ecs cluster will use"
  default     = 8080
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

#TODO Create a new key pair as needed rather than require existing key pair to get passed in
variable "key_pair" {
  description = "The AWS key pair we will be using"
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

# variable "ecs_cluster_type" {
#   description = "Type of ECS Cluster. Values are 'FARGATE' or 'EC2'"
#   default     = "EC2"
# }

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
#NOTE Must have values for same parameter in same order for all 4 fields
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
