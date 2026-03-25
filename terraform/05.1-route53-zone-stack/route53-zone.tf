resource "aws_route53_zone" "this" {
  name          = var.route53_zone.name
  comment       = var.route53_zone.comment
  force_destroy = var.route53_zone.force_destroy
}
