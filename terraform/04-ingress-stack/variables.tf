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

variable "ingress_controller" {
  description = "Parametros planejados para a instalacao do ingress controller."
  type = object({
    type          = string
    namespace     = string
    class_name    = string
    release_name  = string
    chart_name    = string
    chart_version = string
  })

  default = {
    type          = "nginx"
    namespace     = "ingress-nginx"
    class_name    = "nginx"
    release_name  = "ingress-nginx"
    chart_name    = "ingress-nginx"
    chart_version = "4.11.3"
  }
}
