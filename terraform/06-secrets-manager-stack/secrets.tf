resource "aws_secretsmanager_secret" "runtime" {
  for_each = {
    for secret in var.runtime_secrets : secret.name => secret
  }

  name                    = each.value.name
  description             = each.value.description
  recovery_window_in_days = each.value.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "runtime" {
  for_each = {
    for secret_name in keys(nonsensitive(var.runtime_secret_values)) : secret_name => aws_secretsmanager_secret.runtime[secret_name].id
    if contains(keys(aws_secretsmanager_secret.runtime), secret_name)
  }

  secret_id     = each.value
  secret_string = jsonencode(var.runtime_secret_values[each.key])
}
