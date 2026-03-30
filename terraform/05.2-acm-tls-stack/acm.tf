resource "aws_acm_certificate" "hmg" {
  domain_name               = var.acm_tls.primary_domain
  subject_alternative_names = var.acm_tls.subject_alternative_names
  validation_method         = var.acm_tls.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.hmg.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = data.terraform_remote_state.route53_zone.outputs.route53_zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
}

resource "aws_acm_certificate_validation" "hmg" {
  certificate_arn         = aws_acm_certificate.hmg.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
