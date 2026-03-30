resource "kubernetes_annotations" "ingress_nginx_controller_service" {
  api_version = "v1"
  kind        = "Service"

  metadata {
    name      = var.ingress_service.name
    namespace = var.ingress_service.namespace
  }

  annotations = {
    "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = var.ingress_acm_integration.backend_protocol
    "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"         = data.terraform_remote_state.acm_tls.outputs.certificate_arn
    "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"        = var.ingress_acm_integration.ssl_ports
  }

  force = true
}
