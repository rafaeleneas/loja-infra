output "runtime_secret_arns" {
  description = "ARNs dos segredos criados no AWS Secrets Manager."
  value = {
    for name, secret in aws_secretsmanager_secret.runtime : name => secret.arn
  }
}

output "runtime_secret_names" {
  description = "Nomes dos segredos criados no AWS Secrets Manager."
  value = keys(aws_secretsmanager_secret.runtime)
}

output "runtime_secret_versions" {
  description = "Versoes dos segredos gravadas para os segredos com conteudo informado."
  value = {
    for name, secret_version in aws_secretsmanager_secret_version.runtime : name => secret_version.version_id
  }
  sensitive = true
}
