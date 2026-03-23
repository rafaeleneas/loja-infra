# Kubernetes manifests

Manifests da loja organizados com Kustomize em `base` + `overlays`.

A `base` concentra os recursos comuns. Cada `overlay` carrega apenas o que muda por ambiente, como `ConfigMap`, `Secret`, `Ingress`, imagens e patches.

## Como usar

1. Build da imagem do backend no daemon do Minikube:

```powershell
minikube image build -t loja-service:local d:\projetos\lojaBackend\loja-service
```

2. Aplicar namespace e identidade em `dev`:

```powershell
kubectl apply -k d:\projetos\loja\loja-infra\k8s\overlays\dev\keycloak
```

3. Aplicar backend `dev`:

```powershell
kubectl apply -k d:\projetos\loja\loja-infra\k8s\overlays\dev\loja-service
```

4. Validar:

```powershell
kubectl -n loja get deploy,pods,svc
kubectl -n loja rollout status deploy/loja-service
```

5. Testar API:

```powershell
kubectl -n loja port-forward svc/loja-service 8080:8080
```

Depois: `http://localhost:8080/api/loja/actuator/health`

## Overlays

- `k8s/overlays/dev/loja-service`: backend no Minikube e servicos externos no host
- `k8s/overlays/dev/keycloak`: identidade em dev
- `k8s/overlays/hmg/loja-service`: backend em homologacao
- `k8s/overlays/dev/loja-front`: frontend em dev
- `k8s/overlays/hmg/loja-front`: frontend em homologacao
- `k8s/overlays/hmg/keycloak`: identidade em homologacao

Cada overlay possui os manifests de ambiente necessarios.
