module "routes" {
    source = "../routes"
    create_route53            = var.create_route53
    environments              = var.environments
    app_name                  = var.app_name
    domain                    = var.domain
    existing_private_zone     = var.existing_private_zone
    route53_record_type       = var.route53_record_type
    alb_dns_name              = module.jumbo_alb.dns_name
    alb_load_balancer_zone_id = module.jumbo_alb.load_balancer_zone_id
    evaluate_target_health    = var.evaluate_target_health
}
