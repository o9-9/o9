function Invoke-WPFInstallUpgrade {
    <#

    .SYNOPSIS
        Invokes the function that upgrades all installed programs

    #>
    if ($sync.ChocoRadioButton.IsChecked) {
        Install-o9Choco
        $chocoUpgradeStatus = (Start-Process "choco" -ArgumentList "upgrade all -y" -Wait -PassThru -NoNewWindow).ExitCode
        if ($chocoUpgradeStatus -eq 0) {
            Write-Host "Upgrade Successful"
        }
        else{
            Write-Host "Error Occured. Return Code: $chocoUpgradeStatus"
        }
    }
    else{
        if((Test-o9PackageManager -winget) -eq "not-installed") {
            return
        }

        if(Get-o9InstallerProcess -Process $global:WinGetInstall) {
            $msg = "[Invoke-WPFInstallUpgrade] Install process is currently running. Please check for a powershell window labeled 'Winget Install'"
            [System.Windows.MessageBox]::Show($msg, "o9", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
            return
        }

        Update-o9ProgramWinget

        Write-Host "==========================================="
        Write-Host "--           Updates started            ---"
        Write-Host "-- You can close this window if desired ---"
        Write-Host "==========================================="
    }
}

