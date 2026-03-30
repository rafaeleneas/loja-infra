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

variable "eks_remote_state" {
  description = "Configuracao do remote state da stack do EKS."
  type = object({
    bucket = string
    key    = string
    region = string
  })

  default = {
    bucket = "loja-remote-backend-bucket"
    key    = "cluster-eks/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "external_secrets" {
  description = "Configuracao do External Secrets Operator."
  type = object({
    namespace            = string
    chart_version        = string
    service_account_name = string
    secret_name_prefix   = string
    cluster_secret_store = string
    refresh_interval     = string
  })

  default = {
    namespace            = "external-secrets"
    chart_version        = "0.14.4"
    service_account_name = "external-secrets-sa"
    secret_name_prefix   = "loja/"
    cluster_secret_store = "aws-secrets-manager"
    refresh_interval     = "1h"
  }
}
