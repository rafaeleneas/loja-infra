External Secrets bootstrap

This folder prepares the Kubernetes-side wiring for AWS Secrets Manager.

Before adding `external-secret.yaml` to any active overlay, make sure the cluster has:

1. External Secrets Operator installed
2. A service account with AWS access to Secrets Manager
3. The `ClusterSecretStore` in `cluster-secret-store.yaml` applied and working

Only after that should the plain `secret.yaml` files be removed from overlays.
