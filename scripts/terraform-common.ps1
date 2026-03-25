function Invoke-TerraformStack {
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackPath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("apply", "destroy")]
        [string]$Action
    )

    if (-not (Test-Path $StackPath)) {
        Write-Host "[skip] Stack nao encontrada: $StackPath" -ForegroundColor Yellow
        return
    }

    Write-Host ""
    Write-Host "==> $Action :: $StackPath" -ForegroundColor Cyan

    Push-Location $StackPath
    try {
        terraform init -reconfigure
        if ($LASTEXITCODE -ne 0) {
            throw "Falha no terraform init em $StackPath"
        }

        if ($Action -eq "apply") {
            terraform apply
            if ($LASTEXITCODE -ne 0) {
                throw "Falha no terraform apply em $StackPath"
            }
            return
        }

        $stateOutput = & terraform state list 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[skip] Stack sem state utilizavel, pulando destroy: $StackPath" -ForegroundColor Yellow
            return
        }

        if (-not $stateOutput) {
            Write-Host "[skip] Stack sem recursos no state, pulando destroy: $StackPath" -ForegroundColor Yellow
            return
        }

        terraform destroy -auto-approve
        if ($LASTEXITCODE -ne 0) {
            throw "Falha no terraform destroy em $StackPath"
        }
    }
    finally {
        Pop-Location
    }
}
