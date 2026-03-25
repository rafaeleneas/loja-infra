data "terraform_remote_state" "route53_zone" {
  backend = "s3"

  config = {
    bucket = var.route53_zone_remote_state.bucket
    key    = var.route53_zone_remote_state.key
    region = var.route53_zone_remote_state.region
  }
}
