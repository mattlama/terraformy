variable "app_name" {
    description = "Required if creating new VPC. This is the app name which will be used in the creation of all components in this outline"
}

variable "ecs_type" {
  description = "Assign a value here and the script will generate an ecs ec2 container for each element added. Values should be 'FARGATE' or 'EC2'"
}

variable "create" {
  description = "This is a toggle to allow for the resources named here to not get created when we do not want them to"
  default     = false
}

variable "is_ec2" {
  description = "This tells the module whether the ecs cluster we are creating is ec2(true) or fargate(false)"
  type        = bool
}

variable "app_port" {
  description = "Required if creating a new ECS cluster. This is the port traffic for this ecs cluster will use"
}

variable "secure_port" {
  description = "Required if using secure web traffic"
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

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "target_group_arns" {
  description = "The target groups created by the load balancer"
}

variable "alb_listener" {
  description = "The alb listener we need for the load balancer"
}

variable "role_policy_attachment" {
  description = "The role policy attachment used by our ecs cluster when a load balancer is present"
}

variable "network_mode" {
  description = "The network type the task definition will use"
}

variable "is_web_facing" {
  description = "Whether or not to create the alb and route53 entries with the ecs cluster"
}
