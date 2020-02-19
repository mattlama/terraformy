variable "existing_vpc_id" {
    description = "The id of an existing VPC we want to use"
}

variable "existing_security_group_id" {
    description = "The id of an existing VPC we want to use"
}

variable "domain" {
    description = "The domain we want to use for our new route53 entries"
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
