# Terraform da Infra Loja

## Visao geral

As stacks do Terraform em `loja-infra/terraform` estao organizadas em ordem de dependencia.

Fluxo recomendado de subida:

1. `00-remote-backend-stack`
2. `01-networking-stack`
3. `02-cluster-eks-stack`
4. `03-rds-stack`
5. `08-eks-access-stack`
6. `04-ingress-stack`
7. capturar o hostname do LoadBalancer criado pelo ingress
8. `05.1-route53-zone-stack`
9. `05.2-acm-tls-stack`
10. atualizar o `terraform.tfvars` da stack `05.3-dns-stack`
11. `05.3-dns-stack`
12. `05.4-ingress-acm-integration-stack`
13. `06-secrets-manager-stack`
14. `07-external-secrets-stack`

## Blocos do projeto

### Core

As stacks `00` a `03` preparam a base principal da infraestrutura:

- `00-remote-backend-stack`: bucket e lock do state remoto
- `01-networking-stack`: VPC, subnets, rotas e NAT
- `02-cluster-eks-stack`: EKS, node group, IAM e repositorios ECR
- `03-rds-stack`: banco PostgreSQL para a plataforma
- `04-ingress-stack`: ingress controller no cluster

### Acesso ao cluster antes do ingress

A stack `08-eks-access-stack` deve ser aplicada antes da `04-ingress-stack` em ambientes novos.

Motivo:

- a stack `08` libera o acesso administrativo ao EKS para os principals definidos
- isso facilita validacao operacional com `kubectl`
- no fluxo validado do projeto, a reaplicacao da `04` depois da `08` foi necessaria para materializar o ingress no cluster

### Add-ons

As stacks `05` a `08` completam a camada operacional:

- `05.1-route53-zone-stack`: hosted zone publica
- `05.2-acm-tls-stack`: certificado ACM do ambiente `hmg`
- `05.3-dns-stack`: registros DNS publicos de `hmg`
- `05.4-ingress-acm-integration-stack`: annotations do ACM no Service do ingress-nginx para terminação TLS no LoadBalancer
- `06-secrets-manager-stack`: segredos em AWS Secrets Manager
- `07-external-secrets-stack`: External Secrets Operator no cluster
- `08-eks-access-stack`: acessos administrativos ao EKS

## Ponto de atencao entre 04 e 05

Depois de aplicar a stack `04-ingress-stack`, aguarde o Service do ingress receber um hostname de LoadBalancer na AWS.

Exemplo de comando para consultar:

```powershell
kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
```

Esse valor precisa ser colocado no `terraform.tfvars` da stack `05.3-dns-stack`, nos campos:

- `route53.api_target_hostname`
- `route53.auth_target_hostname`

Enquanto esse hostname nao existir ou nao estiver no `terraform.tfvars`, a etapa de DNS nao deve ser aplicada.

## Variaveis minimas esperadas

Quase todas as stacks exigem ao menos:

```hcl
assume_role = {
  arn    = "arn:aws:iam::<account-id>:role/<role-name>"
  region = "us-east-1"
}
```

A stack `03-rds-stack` tambem exige:

```hcl
rds_password = "trocar-esta-senha"
```

A stack `05.1-route53-zone-stack` exige:

```hcl
route53_zone = {
  name = "lojacloud.com.br"
}
```

A stack `05.2-acm-tls-stack` exige:

```hcl
acm_tls = {
  primary_domain = "hmg-api.lojacloud.com.br"
  subject_alternative_names = [
    "hmg-app.lojacloud.com.br",
    "hmg-auth.lojacloud.com.br"
  ]
}
```

A stack `05.3-dns-stack` exige:

```hcl
route53 = {
  app_record_name      = "hmg-app.lojacloud.com.br"
  app_target_hostname  = "<hostname-do-loadbalancer>"
  api_record_name      = "hmg-api.lojacloud.com.br"
  api_target_hostname  = "<hostname-do-loadbalancer>"
  auth_record_name     = "hmg-auth.lojacloud.com.br"
  auth_target_hostname = "<hostname-do-loadbalancer>"
}
```

As stacks `06`, `07` e `08` exigem variaveis especificas para segredos, external secrets e acessos do EKS.

## Scripts

- `05.4-ingress-acm-integration-stack` usa o `certificate_arn` da stack `05.2-acm-tls-stack` e aplica annotations no `Service` `ingress-nginx-controller`, permitindo que o LoadBalancer da AWS faça a terminação TLS com ACM.

Scripts disponiveis em `loja-infra/scripts/terraform`:

- `up-core.ps1`: sobe stacks `00` a `03`
- `up-addons.ps1`: sobe stacks `05.1`, `05.2`, `05.3`, `05.4`, `06` e `07`
- `down-addons.ps1`: destroi stacks `07`, `06`, `05.4`, `05.3`, `05.2` e `05.1`
- `down-core.ps1`: destroi stacks `04`, `08`, `03`, `02` e `01`
- `get-ingress-lb-hostname.ps1`: consulta o hostname atual do LoadBalancer do ingress

Fluxo recomendado:

1. rodar `scripts/terraform/up-core.ps1`
2. aplicar `08-eks-access-stack`
3. aplicar `04-ingress-stack`
4. obter o hostname com `scripts/terraform/get-ingress-lb-hostname.ps1`
5. aplicar `05.1-route53-zone-stack`
6. aplicar `05.2-acm-tls-stack`
7. atualizar `terraform.tfvars` de `05.3-dns-stack`
8. aplicar `05.3-dns-stack`
9. aplicar `05.4-ingress-acm-integration-stack`
10. rodar `scripts/terraform/up-addons.ps1`

Fluxo recomendado de destroy:

1. rodar `scripts/terraform/down-addons.ps1`
2. rodar `scripts/terraform/down-core.ps1`
3. preservar `00-remote-backend-stack`, exceto quando a intencao for remover tambem o backend remoto do Terraform
