function Invoke-WPFFeatureInstall {
    <#

    .SYNOPSIS
        Installs selected Windows Features

    #>

    if($sync.ProcessRunning) {
        $msg = "[Invoke-WPFFeatureInstall] Install process is currently running."
        [System.Windows.MessageBox]::Show($msg, "o9", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    $Features = (Get-o9CheckBoxes)["WPFFeature"]

    Invoke-WPFRunspace -ArgumentList $Features -DebugPreference $DebugPreference -ScriptBlock {
        param($Features, $DebugPreference)
        $sync.ProcessRunning = $true
        if ($Features.count -eq 1) {
            $sync.form.Dispatcher.Invoke([action]{ Set-o9Taskbaritem -state "Indeterminate" -value 0.01 -overlay "logo" })
        } else {
            $sync.form.Dispatcher.Invoke([action]{ Set-o9Taskbaritem -state "Normal" -value 0.01 -overlay "logo" })
        }

        Invoke-o9FeatureInstall $Features

        $sync.ProcessRunning = $false
        $sync.form.Dispatcher.Invoke([action]{ Set-o9Taskbaritem -state "None" -overlay "checkmark" })

        Write-Host "===========================================" -ForegroundColor Cyan
        Write-Host "---        Features are Installed       ---" -ForegroundColor Cyan
        Write-Host "---       A Reboot may be required      ---" -ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan
    }
}
