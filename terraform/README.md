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
8. atualizar o `terraform.tfvars` da stack `05.2-dns-stack`
9. `05.1-route53-zone-stack`
10. `05.2-dns-stack`
11. `06-secrets-manager-stack`
12. `07-external-secrets-stack`

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
- `05.2-dns-stack`: registros DNS da API e do Keycloak
- `06-secrets-manager-stack`: segredos em AWS Secrets Manager
- `07-external-secrets-stack`: External Secrets Operator no cluster
- `08-eks-access-stack`: acessos administrativos ao EKS

## Ponto de atencao entre 04 e 05

Depois de aplicar a stack `04-ingress-stack`, aguarde o Service do ingress receber um hostname de LoadBalancer na AWS.

Exemplo de comando para consultar:

```powershell
kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
```

Esse valor precisa ser colocado no `terraform.tfvars` da stack `05.2-dns-stack`, nos campos:

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
  name = "loja.com"
}
```

A stack `05.2-dns-stack` exige:

```hcl
route53 = {
  api_record_name      = "hmg-api.loja.com"
  api_target_hostname  = "<hostname-do-loadbalancer>"
  auth_record_name     = "hmg-auth.loja.com"
  auth_target_hostname = "<hostname-do-loadbalancer>"
}
```

As stacks `06`, `07` e `08` exigem variaveis especificas para segredos, external secrets e acessos do EKS.

## Scripts

Scripts disponiveis em `loja-infra/scripts/terraform`:

- `up-core.ps1`: sobe stacks `00` a `03`
- `up-addons.ps1`: sobe stacks `05.1` a `07`
- `down-addons.ps1`: destroi stacks `07` a `05.1`
- `down-core.ps1`: destroi stacks `04`, `08`, `03`, `02` e `01`
- `get-ingress-lb-hostname.ps1`: consulta o hostname atual do LoadBalancer do ingress

Fluxo recomendado:

1. rodar `scripts/terraform/up-core.ps1`
2. aplicar `08-eks-access-stack`
3. aplicar `04-ingress-stack`
4. obter o hostname com `scripts/terraform/get-ingress-lb-hostname.ps1`
5. atualizar `terraform.tfvars` de `05.2-dns-stack`
6. rodar `scripts/terraform/up-addons.ps1`

Fluxo recomendado de destroy:

1. rodar `scripts/terraform/down-addons.ps1`
2. rodar `scripts/terraform/down-core.ps1`
3. preservar `00-remote-backend-stack`, exceto quando a intencao for remover tambem o backend remoto do Terraform
