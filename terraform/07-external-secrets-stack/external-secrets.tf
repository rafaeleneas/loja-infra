resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.external_secrets.chart_version
  namespace        = kubernetes_namespace.external_secrets.metadata[0].name
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.external_secrets.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_secrets.arn
  }

  depends_on = [
    kubernetes_namespace.external_secrets,
    aws_iam_role_policy_attachment.external_secrets
  ]
}

resource "time_sleep" "wait_for_external_secrets_crds" {
  depends_on = [helm_release.external_secrets]

  create_duration = "30s"
}

resource "terraform_data" "cluster_secret_store" {
  depends_on = [time_sleep.wait_for_external_secrets_crds]

  input = {
    cluster_secret_store = var.external_secrets.cluster_secret_store
    namespace            = var.external_secrets.namespace
    service_account_name = var.external_secrets.service_account_name
    region               = var.assume_role.region
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-Command"]
    command     = <<-EOT
$manifest = @'
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: ${self.input.cluster_secret_store}
spec:
  provider:
    aws:
      service: SecretsManager
      region: ${self.input.region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${self.input.service_account_name}
            namespace: ${self.input.namespace}
'@

$manifest | kubectl apply -f -
EOT
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["PowerShell", "-NoProfile", "-Command"]
    command     = "kubectl delete clustersecretstore ${self.input.cluster_secret_store} --ignore-not-found=true"
  }
}
