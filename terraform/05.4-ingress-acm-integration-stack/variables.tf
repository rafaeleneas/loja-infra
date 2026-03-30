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

variable "acm_tls_remote_state" {
  description = "Configuracao do remote state da stack do ACM/TLS."
  type = object({
    bucket = string
    key    = string
    region = string
  })

  default = {
    bucket = "loja-remote-backend-bucket"
    key    = "acm-tls/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "ingress_service" {
  description = "Identificacao do Service do ingress-nginx que recebera as annotations do ACM."
  type = object({
    name      = string
    namespace = string
  })

  default = {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

variable "ingress_acm_integration" {
  description = "Parametros de integracao do ACM com o LoadBalancer do ingress."
  type = object({
    backend_protocol = string
    ssl_ports        = string
  })

  default = {
    backend_protocol = "http"
    ssl_ports        = "https"
  }
}
