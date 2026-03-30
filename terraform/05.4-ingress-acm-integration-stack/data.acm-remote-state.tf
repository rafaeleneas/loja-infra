data "terraform_remote_state" "acm_tls" {
  backend = "s3"

  config = {
    bucket = var.acm_tls_remote_state.bucket
    key    = var.acm_tls_remote_state.key
    region = var.acm_tls_remote_state.region
  }
}
