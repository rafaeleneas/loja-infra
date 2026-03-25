output "route53_zone_id" {
  value = data.terraform_remote_state.route53_zone.outputs.route53_zone_id
}

output "api_record_fqdn" {
  value = aws_route53_record.api.fqdn
}

output "auth_record_fqdn" {
  value = aws_route53_record.auth.fqdn
}
