$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$PSNativeCommandUseErrorActionPreference = $false

$repoRoot = Split-Path -Parent $PSScriptRoot
$serviceDir = Join-Path $repoRoot "loja-service"
$kustomizeDir = Join-Path $repoRoot "k8s\base\loja-service"
$namespace = "loja"
$imageName = "loja-service:local"

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Message,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Action
  )

  Write-Host ""
  Write-Host "==> $Message" -ForegroundColor Cyan
  & $Action
}

Invoke-Step "Validando dependencias" {
  foreach ($command in @("minikube", "kubectl")) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
      throw "Comando obrigatorio nao encontrado: $command"
    }
  }
}

Invoke-Step "Verificando status do Minikube" {
  $status = cmd /c "minikube status --format {{.Host}} 2>nul"
  if ($LASTEXITCODE -ne 0 -or $status -ne "Running") {
    throw "Minikube nao esta em execucao."
  }
}

Invoke-Step "Buildando imagem $imageName no daemon do Minikube" {
  minikube image build -t $imageName $serviceDir
}

Invoke-Step "Aplicando manifests do loja-service" {
  kubectl apply -k $kustomizeDir
}

Invoke-Step "Aguardando rollout do deployment" {
  kubectl -n $namespace rollout status deployment/loja-service --timeout=180s
}

Invoke-Step "Resumo dos recursos" {
  kubectl -n $namespace get deploy,pods,svc,ingress
}

Write-Host ""
Write-Host "Deploy concluido." -ForegroundColor Green
Write-Host "Teste sugerido: kubectl -n $namespace port-forward svc/loja-service 8080:8080" -ForegroundColor Green
