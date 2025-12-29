resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = var.alias_domain
  type    = "A"

  alias {
    name                   = aws_lb.alb_ecs_tasks.dns_name
    zone_id                = aws_lb.alb_ecs_tasks.zone_id
    evaluate_target_health = true
  }
}
