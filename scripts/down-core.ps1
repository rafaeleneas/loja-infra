$ErrorActionPreference = "Stop"

. "$PSScriptRoot\terraform-common.ps1"

$root = Split-Path -Parent $PSScriptRoot
$stacks = @(
    "terraform\04-ingress-stack",
    "terraform\03-rds-stack",
    "terraform\02-cluster-eks-stack",
    "terraform\01-networking-stack"
)

foreach ($stack in $stacks) {
    Invoke-TerraformStack -StackPath (Join-Path $root $stack) -Action destroy
}

Write-Host ""
Write-Host "Destroy do core concluido." -ForegroundColor Green
Write-Host "A stack 00-remote-backend-stack foi preservada de proposito." -ForegroundColor Yellow
