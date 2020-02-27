output "security_group_id" {
    # value = length(var.existing_security_group) == 0 ? module.security_group.this_security_group_id: data.aws_security_group.existing[0].id
    value = length(var.existing_security_group) == 0 ? aws_security_group.current[0].id: data.aws_security_group.existing[0].id
}
