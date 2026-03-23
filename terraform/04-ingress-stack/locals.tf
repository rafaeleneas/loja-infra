locals {
  eks_cluster_name = try(data.terraform_remote_state.eks.outputs.eks_cluster_name, null)
}
