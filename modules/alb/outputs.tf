output "alb_listener" {
    value = aws_alb_listener.front_end[0]
}

output "target_group_arns" {
    value = module.alb.target_group_arns
}