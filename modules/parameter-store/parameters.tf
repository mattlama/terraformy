resource "aws_ssm_parameter" "new_parameter" {
  count       = length(var.existing_parameter) > 0 ? 0 : length(var.names)
  name        = var.names[count.index] 
  description = var.descriptions[count.index] 
  type        = var.types[count.index] 
  value       = var.values[count.index] 
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [value]
  }
}

data "aws_ssm_parameter" "my_parameter" {
  count = length(var.existing_parameter)
  name  = var.existing_parameter[0]
}