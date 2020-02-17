module "security_group" {
    source                  = "../security"
    vpc_id                  = module.jumbo_vpc.vpc_id
    app_name                = var.app_name
    existing_security_group = var.existing_security_group
    ingress_rules           = var.ingress_rules
    ingress_cidr_blocks     = var.ingress_cidr_blocks
    egress_rules            = var.egress_rules
    egress_cidr_blocks      = var.egress_cidr_blocks
}
