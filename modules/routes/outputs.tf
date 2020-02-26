output "route53_entries" {
    value = aws_route53_record.new_record.*.name
}
