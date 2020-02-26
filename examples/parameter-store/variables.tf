variable "existing_vpc_id" {
    description = "The id of an existing VPC we want to use"
}

variable "app_name" {
    description = "This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories"
    default     = "test-app"
}

variable "aws_region" {
    description = "This is the aws region for the AWS account the infrastructure will be deployed to"
    default     = "us-east-1"
}

variable "aws_credentials_file_location" {
    description = "This is the location of the credentials file typically found in the $HOME/.aws/ directory. I am using the file location for ease of switching between accounts"
    default     = "$HOME/.aws/credentials"
}

variable "profile" {
    description = "This is the AWS profile to use from the credentials file. Terraform will default to 'default' "
    default     = "testing"
}

variable "existing_parameter_store_name" {
    description = "The name of a parameter store parameter we want to use"
    default     = "/test/secure/message"
}

variable "parameter_names" {
    description = "The names of the parameters we want to create"
    default     = ["/First/message", "/Second/message", "/Third/message"]
}

variable "parameter_descriptions" {
    description = "The descriptions of the parameters we want to create"
    default     = ["Dev", "Qa", "Prod"] 
}

variable "parameter_types" {
    description = "The types of the parameters we want to create"
    default     = ["String", "String", "SecureString"]
}

variable "parameter_values" {
    description = "The values of the parameters we want to create"
    default     = ["password", "password1", "Keep values in terraform.tfvars and add it to .gitignore to keep secure values off git"]
}

variable "parameter_maps" {
    description = "Alternative method of creating parameters which does not rely on keeping 4 separate list up to date"
    default     = [{"name" = "/First/message1", "description" = "Dev", "type" = "String", "value" = "password"},
    {"name" = "/Second/message1", "description" = "Qa", "type" = "String", "value" ="password1"},
    {"name" = "/Third/message1", "description" = "Prod", "type" = "SecureString", "value" ="Keep values in terraform.tfvars and add it to .gitignore to keep secure values off git"},]
}

variable "parameter_maps_hidden" {
    description = "Alternative method of creating parameters which does not rely on keeping 4 separate list up to date"
    default     = [{"name" = "/First/message2", "description" = "Dev", "type" = "String", "value" = "Duck"},
    {"name" = "/Second/message2", "description" = "Qa", "type" = "String", "value" ="Duck"},
    {"name" = "/Third/message2", "description" = "Prod", "type" = "SecureString", "value" =""},]
}

variable "hidden_values" {
    description = "These values are stored in my terraform.tfvars file which is in my gitignore. I will use these values and insert them into the parameter_maps values"
}
