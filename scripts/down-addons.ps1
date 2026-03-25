$ErrorActionPreference = "Stop"

. "$PSScriptRoot\terraform-common.ps1"

$root = Split-Path -Parent $PSScriptRoot
$stacks = @(
    "terraform\08-eks-access-stack",
    "terraform\07-external-secrets-stack",
    "terraform\06-secrets-manager-stack",
    "terraform\05.2-dns-stack",
    "terraform\05.1-route53-zone-stack"
)

foreach ($stack in $stacks) {
    Invoke-TerraformStack -StackPath (Join-Path $root $stack) -Action destroy
}

Write-Host ""
Write-Host "Destroy dos add-ons concluido." -ForegroundColor Green
