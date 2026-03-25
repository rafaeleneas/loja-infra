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

variable "route53_zone" {
  description = "Configuracao da hosted zone publica principal do projeto."
  type = object({
    name          = string
    comment       = optional(string, "Hosted zone publica do projeto loja")
    force_destroy = optional(bool, false)
  })
}
