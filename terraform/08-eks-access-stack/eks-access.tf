locals {
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name
  access_entries = {
    for entry in var.eks_access_entries : entry.principal_arn => entry
  }
}

resource "aws_eks_access_entry" "this" {
  for_each = local.access_entries

  cluster_name      = local.cluster_name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = each.value.kubernetes_groups
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  for_each = local.access_entries

  cluster_name  = local.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type = each.value.access_scope_type
  }
}
