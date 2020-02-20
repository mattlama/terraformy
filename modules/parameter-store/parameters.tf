resource "aws_ssm_parameter" "new_parameter" {
  count       = length(var.existing_parameter) > 0 ? 0 : length(var.parameters)
  name        = var.parameters[count.index]["name"] 
  description = var.parameters[count.index]["description"]
  type        = var.parameters[count.index]["type"]
  value       = var.parameters[count.index]["value"]
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [value]
  }
}

data "aws_ssm_parameter" "my_parameter" {
  count = length(var.existing_parameter)
  name  = var.existing_parameter[0]
}