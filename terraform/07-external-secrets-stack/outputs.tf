output "external_secrets_role_arn" {
  value = aws_iam_role.external_secrets.arn
}

output "cluster_secret_store_name" {
  value = terraform_data.cluster_secret_store.input.cluster_secret_store
}

output "external_secrets_namespace" {
  value = kubernetes_namespace.external_secrets.metadata[0].name
}
