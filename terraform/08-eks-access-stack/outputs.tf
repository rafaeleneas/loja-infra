output "eks_cluster_name" {
  value = local.cluster_name
}

output "eks_access_principals" {
  value = keys(local.access_entries)
}
