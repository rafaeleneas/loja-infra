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

variable "eks_access_entries" {
  description = "Entradas administrativas do EKS para usuarios e roles do ambiente."
  type = list(object({
    principal_arn     = string
    kubernetes_groups = optional(list(string), [])
    policy_arn        = optional(string, "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy")
    access_scope_type = optional(string, "cluster")
  }))
}
