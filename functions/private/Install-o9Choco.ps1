function Install-o9Choco {

    <#

    .SYNOPSIS
        Installs Chocolatey if it is not already installed

    #>

    try {
        Write-Host "Checking if Chocolatey is Installed..."

        if((Test-o9PackageManager -choco) -eq "installed") {
            return
        }
        # Install logic taken from https://chocolatey.org/install#individual
        Write-Host "Seems Chocolatey is not installed, installing now."
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    } catch {
        Write-Host "┌────────────────────────────────────────────┐" -ForegroundColor Cyan
        Write-Host "│         Chocolatey failed to install       │" -ForegroundColor Cyan
        Write-Host "└────────────────────────────────────────────┘" -ForegroundColor Cyan
    }

}

