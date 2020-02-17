output "value" {
  value = length(var.existing_parameter) > 0 ? data.aws_ssm_parameter.my_parameter[0].value: ""
}