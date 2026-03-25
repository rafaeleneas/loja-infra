$ErrorActionPreference = "Stop"

. "$PSScriptRoot\terraform-common.ps1"

$root = Split-Path -Parent $PSScriptRoot
$stacks = @(
    "terraform\05.1-route53-zone-stack",
    "terraform\05.2-dns-stack",
    "terraform\06-secrets-manager-stack",
    "terraform\07-external-secrets-stack",
    "terraform\08-eks-access-stack"
)

foreach ($stack in $stacks) {
    Invoke-TerraformStack -StackPath (Join-Path $root $stack) -Action apply
}

Write-Host ""
Write-Host "Add-ons concluidos." -ForegroundColor Green
Write-Host "Lembretes:" -ForegroundColor Green
Write-Host "- preencher os valores dos segredos no AWS Secrets Manager"
Write-Host "- se o External Secrets Operator foi instalado, migrar overlays para external-secret.yaml"
Write-Host "- validar acessos administrativos ao EKS"
Write-Host "- revisar DNS da API e do Keycloak"
