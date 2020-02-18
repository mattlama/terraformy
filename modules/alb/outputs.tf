output "alb_listener" {
    value = aws_alb_listener.front_end[0]
}

output "target_group_arns" {
    value = module.alb.target_group_arns
}

output "dns_name" {
    value = module.alb.dns_name
}

output "load_balancer_zone_id" {
    value = module.alb.load_balancer_zone_id
}
