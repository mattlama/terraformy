provider "aws" {
    region                  = var.aws_region
    shared_credentials_file = var.aws_credentials_file_location
    profile                 = var.profile
}

# Example create new lambda
module "terraformy_new" {
    source     = "../../../terraformy"
    app_name   = var.app_name # Required. This is the app name which will be used in the creation of all components in this outline. NOTE AWS has limitations on certain components such as 32 characters in length or must be all lowercase for ecr repositories
    aws_region = var.aws_region # Required if creating a new ECS cluster. This is the region the ECS cluster will live in
    #Tags
    owners   = [] # This will apply the first owner provided to all the Owner fields in tags. It will default to Terraform as owner in tags.tf if none are provided
    projects = [] # This will apply the first project provided to all the Project fields in tags. It will default to Terraform-AppName as project in tags.tf if none are provided

    #VPC
    existing_vpcs        = [var.existing_vpc_id]  # If the user wants to put their new components into an existing VPC they may do so. This is an array of VPC ids but will only use the first value
    #Security
    existing_security_group = [var.existing_security_group_id] # Leave blank to create a new security group. Otherwise it will use the VPC id to find an associated security group

    #lambda
    create_lambda             = true            # Toggles whether or not to create the lambda function
    lambda_cloudwatch_logging = true            # Adds cloudwatch logging to the lambda alias
    alias_name                = ["test"]        # In the current version an alias will not get created without cloudwatch logging as that is the only element which uses an alias
    lambda_s3_key             = "test/file.txt" # The location of the build file 
    #Optional fields
#     environments              = ["dev", "qa", "prod"]
#     lambda_cloudwatch_logging_retention_in_days = 14 # How long to retain cloudwatch logs
#     alias_function_version    = ["1"] # The version we want our function alias to use
#     schedule_expression       = "rate(1 minute)" # The schedule expression used in our cloudwatch event rule
#     lambda_timeout            = 20 # The timeout for the lambda function
#     handler                   = "main" # The handler our lambda will use
#     lambda_runtime            = "go1.x" # The runtime environment for our lambda
#     existing_lambda           = [] # If we want to add cloudwatch logging to an existing lambda functino rather than creating a new one give the function arn here
#     existing_lambda_role      = [] # If we have an existing iam role we want to use for our lambda function pass in the role policy here
#     lambda_s3_bucket          = [] # The bucket name of an existing bucket. Used in the case where we are not creating a new S3 bucket and do not want to reference one outside of lambda generation

}

# This will create the following:
# cloudwatch event rule (1)
# cloudwatch event target (1 for each environment)
# cloudwatch log group (1 for each environment)
# lambda alias (1 for each environment)
# lambda function (1 for each environment)
# lambda permission cloudwatch (1 for each lambda function)
# For a total of 1 + 3 + 3 + 3 + 3 + 3 = 16 components created
