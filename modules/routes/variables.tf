variable "environments" {
    description = "The environments we want to create for our routes"
}

variable "app_name" {
    description = "This is the app name which will be used in the creation of all components in this outline"
}

variable "create_route53" {
    description = "Whether or not to create route53 entries"
}

variable "domain" {
    description = "The domain our routes will use"
}

variable "existing_private_zone" {
    description = "Whether or not the existing zone is private or not"
    type        = bool
}

variable "route53_record_type" {
    description = "The type of route53 we want to create"
}

variable "alb_dns_name" {
    description = "The dns name of the alb we want to use"
}

variable "alb_load_balancer_zone_id" {
    description = "The zone id of the load balancer we want to use"
}

variable "evaluate_target_health" {
    description = "Whether or not to track target health"
    type        = bool
}