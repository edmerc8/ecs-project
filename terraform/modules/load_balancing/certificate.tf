resource "aws_acm_certificate" "cert" {
  domain_name       = var.alias_domain
  validation_method = "DNS"

  lifecycle {
    # Needed for certificate rotation w/o downtime
    create_before_destroy = true
  }
}

# DNS Validation Record (Using for_each to handle multiple SANs)
# In this case there should only be one dvo (Domain Validation Object)
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
  allow_overwrite = true

}

# Terraform waits until the cert has been validated and moved to "Issued" before advancing
resource "aws_acm_certificate_validation" "cert_verify" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
