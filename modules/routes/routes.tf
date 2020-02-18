data "aws_route53_zone" "selected" {
  count        = var.create_route53 ? 1 : 0 
  name         = var.domain
  private_zone = var.existing_private_zone
}

resource "aws_route53_record" "new_record" {
  count   = var.create_route53 ? length(var.environments): 0
  zone_id = "${data.aws_route53_zone.selected[0].zone_id}"
  name    = "${var.environments[count.index]}-${var.app_name}.${data.aws_route53_zone.selected[0].name}"
  type    = var.route53_record_type 

  alias {
    name                   = var.alb_dns_name 
    zone_id                = var.alb_load_balancer_zone_id 
    evaluate_target_health = var.evaluate_target_health
  }
}
