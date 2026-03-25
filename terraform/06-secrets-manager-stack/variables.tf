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

variable "runtime_secrets" {
  description = "Lista de segredos de runtime das aplicacoes. O valor secreto fica fora do Git."
  type = list(object({
    name                    = string
    description             = string
    recovery_window_in_days = optional(number, 7)
  }))
}

variable "runtime_secret_values" {
  description = "Mapa sensivel com o conteudo JSON de cada segredo, indexado pelo nome do segredo."
  type        = map(map(string))
  default     = {}
  sensitive   = true
}
