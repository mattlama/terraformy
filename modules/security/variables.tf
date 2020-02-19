variable "app_name" {
    description = "Required. This is the app name which will be used in the creation of all components in this outline"
}

variable "vpc_id" {
    description = "Required. This is the VPC the security group will belong to"
}

variable "existing_security_group" {
    description = "Leave blank to create a new security group. Otherwise it will use the VPC id to find an associated security group"
}

variable "security_groups_to_create" {
    description = "A list of fields required to create the security group. In list format so many security groups can be created"
}

#Tags
variable "owners" {
    description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
}

variable "projects" {
    description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
}