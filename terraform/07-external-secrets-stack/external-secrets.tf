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

resource "kubernetes_manifest" "cluster_secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = var.external_secrets.cluster_secret_store
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.assume_role.region
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = var.external_secrets.service_account_name
                namespace = var.external_secrets.namespace
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.external_secrets]
}
