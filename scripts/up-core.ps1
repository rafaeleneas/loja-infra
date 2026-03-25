$ErrorActionPreference = "Stop"

. "$PSScriptRoot\terraform-common.ps1"

$root = Split-Path -Parent $PSScriptRoot
$stacks = @(
    "terraform\00-remote-backend-stack",
    "terraform\01-networking-stack",
    "terraform\02-cluster-eks-stack",
    "terraform\03-rds-stack",
    "terraform\04-ingress-stack"
)

foreach ($stack in $stacks) {
    Invoke-TerraformStack -StackPath (Join-Path $root $stack) -Action apply
}

Write-Host ""
Write-Host "Infra core concluida." -ForegroundColor Green
Write-Host "Lembretes:" -ForegroundColor Green
Write-Host "- atualizar kubeconfig: aws eks update-kubeconfig --region us-east-1 --name loja-eks-cluster"
Write-Host "- instalar/validar ArgoCD no cluster"
Write-Host "- verificar se o secret AWS_GITHUB_ROLE_ARN continua correto no GitHub"
Write-Host "- se o ELB mudar, atualizar DNS de hmg-api.loja.com e hmg-auth.loja.com"
