resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.ingress_controller.namespace
  }
}
