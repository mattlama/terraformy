output "iam_role_name" {
    value = aws_iam_role.new_role[0].name
}

output "iam_role_arn" {
    value = aws_iam_role.new_role[0].arn
}

output "iam_role_policy_attachment" {
    value = aws_iam_role_policy_attachment.role_attachment
}