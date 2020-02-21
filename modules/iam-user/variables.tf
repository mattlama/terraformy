variable "app_name" {
    description = "This is the app name which will be used in the creation of all components in this outline"
}

variable "owners" {
    description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
}

variable "projects" {
    description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
}

variable "users" {
    description = "A slice of maps containing the values needed to create users. Fields are 'name', and 'policies'. name will default to app_name-devops if left blank"
}

variable "ecr_repository_arn" {
    description = "ECR Repository arn we want our user to be able to access"
}