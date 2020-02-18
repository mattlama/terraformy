variable "create_alb" {
    description = "Whether or not to create a new alb"
}

variable "environments" {
    description = "The environments we want to create for our alb target groups"
}

variable "public_subnets" {
    description = "The VPCs public subnets. Used in network configuration"
}

variable "app_name" {
    description = "This is the app name which will be used in the creation of all components in this outline"
}

variable "security_group_id" {
    description = "The security group we will be putting in front of the alb"
}

variable "vpc_id" {
    description = "Required. This is the VPC the alb will belong to"
}

variable "logging_enabled" {
    description = "Whether the default logging is enabled in the alb"
}

variable "owners" {
    description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
}

variable "projects" {
    description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
}

variable "ecs_port" {
    description = "Port exposed by the docker image to redirect traffic to"
}

variable "secure_port" {
    description = "The secure port used by our alb"
}

variable "target_groups_count" {
    description = "The number of target groups we will be creating"
}

variable "target_groups" {
    description = "The target groups our alb will be using"
}

variable "alb_listener_protocol" {
    description = "Protocol our alb listener uses"
}

variable "alb_ssl_policy" {
    description = "Policy our alb listener uses"
}

variable "certificate_arn" {
    description = "If HTTPS is used a certificate arn is required"
}

variable "domain" {
    description = "Domain we will be using for this alb"
}
