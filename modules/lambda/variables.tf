variable "lambda_role_name" {
  description = "The name of the role this lambda will use"
}

variable "environments" {
  description = "The environments we want to create these lambda function in"
}

variable "app_name" {
  description = "The name of our application"
}

variable "lambda_cloudwatch_logging" {
  description = "When true will create cloudwatch logging for our lambda function"
  type        = bool
}

variable "lambda_cloudwatch_logging_retention_in_days" {
  description = "How long to retain cloudwatch logs"
}

variable "alias_name" {
  description = "Name for an alias for our lambda function"
}

variable "alias_function_version" {
  description = "The version we want our function alias to use"
}

variable "s3_bucket" {
  description = "The S3 bucket our lambda will use"
}

variable "s3_key" {
  description = "The key our lambda will use to find boot file"
}

variable "private_subnets" {
  description = "The subnets our lambda will use"
}

variable "security_group_id" {
  description = "The security group used by our lambda"
}

variable "lambda_runtime" {
  description = "The runtime environment for our lambda"
}

variable "lambda_iam_role_arn" {
  description = "The arn of the lambda iam role policy we want to use"
}

variable "handler" {
  description = "The handler our lambda will use"
}

variable "owners" {
  description = "This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided"
}

variable "projects" {
  description = "This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided"
}

variable "schedule_expression" {
  description = "The schedule expression used in our cloudwatch event rule"
}

variable "create_lambda" {
  description = "Whether or not to create a lambda expression"
}

variable "lambda_timeout" {
  description = "The timeout for the lambda function"
}

variable "existing_lambda" {
  description = "The arn of an existing lambda expression. Used to add cloudwatch logging or an alias to an existing expression"
}
