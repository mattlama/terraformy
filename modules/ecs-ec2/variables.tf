variable "app_name" {
    description = "Required if creating new VPC. This is the app name which will be used in the creation of all components in this outline"
}

variable "ecs_ec2_container" {
  description = "Assign a value here and the script will generate an ecs ec2 container for each element added. Values should be 'FARGATE' or 'EC2'"
}

variable "create" {
    description = "This is a toggle to allow for the resources named here to not get created when we do not want them to"
    default     = false
}

variable "app_port" {
    description = "Required if creating a new ECS cluster. This is the port traffic for this ecs cluster will use"
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
}

variable "container_count" {
    description = "Number of containers to run"
    default     = 3
}

variable "security_group_id" {
    description = "The security group we will be putting in front of the cluster"
}

variable "public_subnets" {
    description = "The VPCs public subnets. Used in network configuration"
}

variable "execution_role_arn" {
    description = "The ecs task execution role arn "
}

variable "instance_role_name" {
    description = "The instances we are creating require an iam role or else they cannot launch"
}

variable "instance_type" {
    description = "The type of EC2 instance we want to use"
}

# TODO Create a new key pair as needed rather than require existing key pair to get passed in
variable "key_pair" {
    description = "The AWS key pair we will be using"
}

variable "instance_root_volume_size" {
  description = "Root volume size"
}

variable "asg_max_size" {
  description = "Maximum number EC2 instances"
}

variable "asg_min_size" {
  description = "Minimum number of instances"
}

variable "asg_desired_size" {
  description = "Desired number of instances"
}

# variable "ecs_cluster_type" {
#   description = "Type of ECS Cluster. Values are 'FARGATE' or 'EC2'"
# }
