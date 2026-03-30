output "certificate_arn" {
  value = aws_acm_certificate_validation.hmg.certificate_arn
}

output "certificate_domain_name" {
  value = aws_acm_certificate.hmg.domain_name
}

output "certificate_subject_alternative_names" {
  value = aws_acm_certificate.hmg.subject_alternative_names
}

output "validation_record_fqdns" {
  value = [for record in aws_route53_record.validation : record.fqdn]
}
