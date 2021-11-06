resource "aws_acm_certificate" "website" {
  domain_name       = local.domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "website" {
  certificate_arn         = aws_acm_certificate.website.arn
  validation_record_fqdns = [for record in aws_route53_record.website_validation : record.fqdn]
}