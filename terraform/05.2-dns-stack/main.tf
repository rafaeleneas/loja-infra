terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "loja-remote-backend-bucket"
    key          = "dns-records/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.assume_role.region

  assume_role {
    role_arn = var.assume_role.arn
  }

  default_tags {
    tags = var.tags
  }
}

resource "aws_route53_record" "api" {
  zone_id = data.terraform_remote_state.route53_zone.outputs.route53_zone_id
  name    = var.route53.api_record_name
  type    = "CNAME"
  ttl     = 300
  records = [var.route53.api_target_hostname]
}

resource "aws_route53_record" "auth" {
  zone_id = data.terraform_remote_state.route53_zone.outputs.route53_zone_id
  name    = var.route53.auth_record_name
  type    = "CNAME"
  ttl     = 300
  records = [var.route53.auth_target_hostname]
}
