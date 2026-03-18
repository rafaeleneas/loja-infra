# Kubernetes manifests

Manifests para subir apenas o `loja-service` no Minikube.

Banco e Keycloak ficam externos ao cluster (Docker local/host).

## Como usar

1. Build da imagem da app no daemon do Minikube:

```powershell
minikube image build -t loja-service:local d:\projetos\lojaBackend\loja-service
```

2. Aplicar manifests:

```powershell
kubectl apply -k d:\projetos\lojaBackend\k8s\base\loja-service
```

3. Validar:

```powershell
kubectl -n loja get deploy,pods,svc
kubectl -n loja rollout status deploy/loja-service
```

4. Testar API:

```powershell
kubectl -n loja port-forward svc/loja-service 8080:8080
```

Depois: `http://localhost:8080/api/loja/actuator/health`

## URLs externas usadas pelo pod

- `KEYCLOAK_URL=http://host.minikube.internal:8081`
- `DATABASE_URL=jdbc:postgresql://host.minikube.internal:5433/lojadb`

## Deploy automatizado local

```powershell
powershell -ExecutionPolicy Bypass -File d:\projetos\lojaBackend\k8s\deploy-backend-local.ps1
```
