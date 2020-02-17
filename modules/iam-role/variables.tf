variable "role_type" {
  description = "Give either 'ECS', 'ASG', or 'EC2' as input types and roles will be created accordingly. Note at this time EC2 is the default if there is no recognized value and it requires a custom policy"
  default     = []
}

variable "custom_policy" {
  description = "Pass in a custom policy document"
  default     = []
}

#Tags
variable "app_name" {
  description = "Required. This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories"
}

variable "owners" {
  description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
}

variable "projects" {
  description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
}
