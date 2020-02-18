module "lambda" {
  source = "../lambda"
  create_lambda                               = var.create_lambda ? (length(var.existing_lambda) > 0 ? false : true): false
  lambda_role_name                            = module.lambda_iam_role.iam_role_name 
  environments                                = var.environments
  app_name                                    = var.app_name
  lambda_cloudwatch_logging                   = var.lambda_cloudwatch_logging
  lambda_cloudwatch_logging_retention_in_days = var.lambda_cloudwatch_logging_retention_in_days
  alias_name                                  = var.alias_name
  alias_function_version                      = var.alias_function_version
  s3_bucket                                   = length(var.lambda_s3_bucket) > 0 ? var.lambda_s3_bucket[0] : module.s3_bucket.bucket_name
  s3_key                                      = var.lambda_s3_key
  private_subnets                             = module.jumbo_vpc.vpc_private_subents
  security_group_id                           = module.security_group.security_group_id
  lambda_runtime                              = var.lambda_runtime
  lambda_iam_role_arn                         = module.lambda_iam_role.iam_role_arn
  handler                                     = var.handler
  owners                                      = var.owners
  projects                                    = var.projects
  schedule_expression                         = var.schedule_expression
  lambda_timeout                              = var.lambda_timeout
  existing_lambda                             = var.existing_lambda
}

module "lambda_iam_role" {
  source        = "../iam-role"
  create        = var.create_lambda
  app_name      = var.app_name
  owners        = var.owners
  projects      = var.projects
  role_type     = length(var.existing_lambda_role) > 0 ? ["lambda"]: []
  custom_policy = [var.lambda_role_policy, var.lambda_policy]
}
