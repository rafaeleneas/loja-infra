# Observabilidade Dev

Stack inicial de observabilidade do ambiente `dev` com:

- `Prometheus` para coleta de metricas
- `Grafana` para exploracao e dashboards

Alvos configurados no `Prometheus`:

- `loja-service.loja.svc.cluster.local:8080/api/loja/actuator/prometheus`
- `keycloak.loja.svc.cluster.local:8080/metrics`

Acesso inicial sugerido:

```powershell
kubectl port-forward -n loja svc/grafana 3000:3000
kubectl port-forward -n loja svc/prometheus 9090:9090
```

Acesso preferencial via ingress:

- Grafana: `https://grafana.dev.lojacloud.com.br`

Endpoints locais:

- Grafana: `http://localhost:3000`
- Prometheus: `http://localhost:9090`

Credenciais padrao do Grafana no `dev`:

- usuario: `admin`
- senha: `admin`
