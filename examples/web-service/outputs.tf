output "route53_routes" {
    value = module.terraformy_web_service.route53_entries
}

output "ecr_arn" {
    value = module.terraformy_web_service.ecr_repository_arn
}
