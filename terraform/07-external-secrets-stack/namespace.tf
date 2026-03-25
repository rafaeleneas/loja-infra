resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = var.external_secrets.namespace
  }
}
