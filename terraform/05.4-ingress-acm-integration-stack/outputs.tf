output "eks_cluster_name" {
  value = local.eks_cluster_name
}

output "certificate_arn" {
  value = data.terraform_remote_state.acm_tls.outputs.certificate_arn
}

output "annotated_ingress_service_name" {
  value = var.ingress_service.name
}

output "annotated_ingress_service_namespace" {
  value = var.ingress_service.namespace
}
