variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "loja"
  }
}

variable "assume_role" {
  description = "Role e regiao usadas pelo provider AWS. Defina em terraform.tfvars local."
  type = object({
    arn    = string
    region = string
  })
}

variable "route53_zone_remote_state" {
  description = "Configuracao do remote state da stack da hosted zone Route53."
  type = object({
    bucket = string
    key    = string
    region = string
  })

  default = {
    bucket = "loja-remote-backend-bucket"
    key    = "route53-zone/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "acm_tls" {
  description = "Configuracao do certificado ACM usado no ambiente hmg."
  type = object({
    primary_domain            = string
    subject_alternative_names = list(string)
    validation_method         = optional(string, "DNS")
  })
}
