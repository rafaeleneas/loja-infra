data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

data "aws_caller_identity" "current" {}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}
