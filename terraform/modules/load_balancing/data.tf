data "aws_route53_zone" "hosted_zone" {
  name         = var.alias_domain
  private_zone = false
}
