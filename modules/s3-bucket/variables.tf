variable "create" {
  description = "Whether or not to create the s3 bucket"
}

variable "existing_bucket" {
  description = "The name of an existing bucket"
  default     = []
}

variable "app_name" {
  description = "This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories"
}

#Tags
variable "owners" {
  description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
}

variable "projects" {
  description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
}