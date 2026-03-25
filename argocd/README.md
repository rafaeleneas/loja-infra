# Argo CD layout

- `argocd/dev` and `argocd/hmg` contain the day-to-day Applications for each component.
- These Applications point directly to `k8s/overlays/<env>/<component>`, so image tag changes in overlays are reconciled normally.
- `argocd/bootstrap/dev` and `argocd/bootstrap/hmg` are optional app-of-apps manifests for initial environment bootstrap only.
- Use bootstrap when you want Argo CD to create the component Applications in order.
- For regular delivery, keep using the component Applications directly.
