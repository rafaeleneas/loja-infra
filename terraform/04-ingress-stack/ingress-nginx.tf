resource "helm_release" "ingress_nginx" {
  name             = var.ingress_controller.release_name
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = var.ingress_controller.chart_name
  version          = var.ingress_controller.chart_version
  namespace        = kubernetes_namespace.ingress_nginx.metadata[0].name
  create_namespace = false

  set {
    name  = "controller.ingressClass"
    value = var.ingress_controller.class_name
  }

  set {
    name  = "controller.ingressClassResource.name"
    value = var.ingress_controller.class_name
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  depends_on = [
    kubernetes_namespace.ingress_nginx,
  ]
}
