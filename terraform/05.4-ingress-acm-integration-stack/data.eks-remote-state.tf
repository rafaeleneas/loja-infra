data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = var.eks_remote_state.bucket
    key    = var.eks_remote_state.key
    region = var.eks_remote_state.region
  }
}
