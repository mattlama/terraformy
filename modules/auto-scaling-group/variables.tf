variable "app_name" {
  description = "Required if creating new VPC. This is the app name which will be used in the creation of all components in this outline"
}

variable "create" {
  description = "Whether or not to create the Autoscaling group resources"
  default     = false
}

variable "environments" {
  description = "The environments we want to create for our ecs service"
}

variable "ecs_cluster_name" {
  description = "The ecs cluster we will be using"
}

variable "auto_scaling_role_iam_arn" {
  description = "The autoscaling permissions associated with the autoscaling group we will be creating"
}

variable "asg_min_capacity" {
  description = "Minimum running instances in the autoscaling group"
}

variable "asg_max_capacity" {
  description = "Maximum running instances in the autoscaling group"
}
