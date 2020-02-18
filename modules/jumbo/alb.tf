module "jumbo_alb" {
    source = "../alb"
    create_alb            = var.create_alb
    environments          = var.environments
    public_subnets        = module.jumbo_vpc.vpc_public_subents
    app_name              = var.app_name
    security_group_id     = module.security_group.security_group_id
    vpc_id                = module.jumbo_vpc.vpc_id
    logging_enabled       = var.alb_logging_enabled
    owners                = var.owners
    projects              = var.projects
    ecs_port              = var.app_port
    secure_port           = var.secure_port
    target_groups_count   = length(var.environments)
    alb_listener_protocol = var.alb_listener_protocol
    alb_ssl_policy        = var.alb_ssl_policy
    # TODO: Create new data cert is not implemented
    certificate_arn       = var.existing_certificate_arn[0]
    domain                = var.domain

    target_groups         = [
        for e in var.environments:
        map("name", "${e}-${var.app_name}-tg", "backend_protocol", "HTTP", "backend_port", "${var.app_port}", "target_type", "ip", "health_check_path", "/healthcheck")
    ]  
}
