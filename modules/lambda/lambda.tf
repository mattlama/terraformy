resource "aws_cloudwatch_log_group" "example" {
  count             = var.create_lambda ? (var.lambda_cloudwatch_logging ? length(var.environments): 0) : (length(var.existing_lambda) > 0 ? (var.lambda_cloudwatch_logging ? length(var.environments): 0): 0)
  name              = "/aws/lambda/${var.environments[count.index]}/${var.app_name}"
  retention_in_days = var.lambda_cloudwatch_logging_retention_in_days 
}

resource "aws_lambda_permission" "cloudwatch" {
  count         = var.create_lambda ? (var.lambda_cloudwatch_logging ? length(var.environments): 0) : (length(var.existing_lambda) > 0 ? (var.lambda_cloudwatch_logging ? length(var.environments): 0): 0)
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_alias.live_alias[count.index].arn
  qualifier     = aws_lambda_alias.live_alias[count.index].name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[0].arn
}

resource "aws_cloudwatch_event_rule" "lambda" {
  count               = var.create_lambda ? (var.lambda_cloudwatch_logging ? 1: 0) : (length(var.existing_lambda) > 0 ? (var.lambda_cloudwatch_logging ? 1: 0): 0)
  schedule_expression = var.schedule_expression 
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = var.create_lambda ? (var.lambda_cloudwatch_logging ? length(var.environments): 0) : (length(var.existing_lambda) > 0 ? (var.lambda_cloudwatch_logging ? length(var.environments): 0): 0)
  rule  = aws_cloudwatch_event_rule.lambda[0].name
  arn   = aws_lambda_alias.live_alias[count.index].arn
}


resource "aws_lambda_function" "new_lambda" {
  count         = var.create_lambda ? length(var.environments) : 0
  function_name = "${var.app_name}-${var.environments[count.index]}"
  role          = "${var.lambda_iam_role_arn}"
  handler       = var.handler
  s3_bucket     = var.s3_bucket
  s3_key        = "${var.s3_key}"
  timeout       = var.lambda_timeout

  description = "${var.app_name}-${var.environments[count.index]} will maintain redis locks for the ${var.app_name} service"
  runtime     = var.lambda_runtime

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      ENV = "${var.environments[count.index]}"
    }
  }

  tags = "${merge(
    local.lambda_tags,
    map(
      "ENV", var.environments[count.index]
    )
  )}"
}

# NOTE If we want multiple aliases assigned for each environment like this we will need to create a module or separate resource for each
resource "aws_lambda_alias" "live_alias" {
  # Conditions: Create lambda is true, we have an alias name, and cloudwatch logging is set to true
  count            = var.create_lambda ? (var.lambda_cloudwatch_logging ? length(var.environments): 0) : (length(var.existing_lambda) > 0 ? (var.lambda_cloudwatch_logging ? length(var.environments): 0) : 0)
  name             = var.alias_name[0] 
  function_name    = length(var.existing_lambda) > 0 ? var.existing_lambda[0]: aws_lambda_function.new_lambda[count.index].arn
  function_version = var.alias_function_version[0] 
}

data "aws_lambda_function" {
  count         = length(var.existing_lambda) > 0 ? 1 : 0
  function_name = var.existing_lambda[0]
}