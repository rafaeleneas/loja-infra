output "eks_cluster_name" {
  value = local.eks_cluster_name
}

output "planned_ingress_controller_type" {
  value = var.ingress_controller.type
}

output "planned_ingress_controller_namespace" {
  value = var.ingress_controller.namespace
}

output "planned_ingress_class_name" {
  value = var.ingress_controller.class_name
}

output "ingress_controller_namespace" {
  value = kubernetes_namespace.ingress_nginx.metadata[0].name
}

output "ingress_controller_release_name" {
  value = helm_release.ingress_nginx.name
}
