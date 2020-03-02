# Refer here for documentation
# https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/4.1.0

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "4.1.0"
  create_alb          = var.create_alb
  load_balancer_name  = "${var.app_name}-LoadBalancer"
  subnets             = var.public_subnets
  security_groups     = [var.security_group_id]
  vpc_id              = var.vpc_id
  logging_enabled     = var.logging_enabled
  target_groups       = "${tolist(var.target_groups)}"
  target_groups_count = var.create_alb ? length(var.target_groups) :0
  tags                = {
    Terraform   = "true"
    Application = var.app_name
    Owner       = length(var.owners) == 0 ? "Terraform": var.owners[0]
    Project     = length(var.projects) == 0 ? "Terraform-${var.app_name}": var.projects[0]
  }
}

resource "aws_alb_listener" "front_end" {
  count             = var.create_alb ? 1 : 0
  load_balancer_arn = module.alb.load_balancer_id
  port              = var.secure_port
  protocol          = var.alb_listener_protocol
  ssl_policy        = var.alb_ssl_policy 
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = module.alb.target_group_arns[0]
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "redirect-to-env" {
  count        = var.create_alb ? length(var.environments): 0
  listener_arn = "${aws_alb_listener.front_end[0].arn}"

  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[count.index]
  }

  condition {
    field  = "host-header"
    values = ["${var.environments[count.index]}-${var.app_name}.${var.domain}"]
  }
}
