function Invoke-WPFFixesWinget {

    <#

    .SYNOPSIS
        Fixes Winget by running choco install winget
    .DESCRIPTION
        BravoNorris for the fantastic idea of a button to reinstall winget
    #>
    # Install Choco if not already present
    try {
        Set-o9Taskbaritem -state "Indeterminate" -overlay "logo"
        Install-o9Choco
        Start-Process -FilePath "choco" -ArgumentList "install winget -y --force" -NoNewWindow -Wait
    } catch {
        Write-Error "Failed to install winget: $_"
        Set-o9Taskbaritem -state "Error" -overlay "warning"
    } finally {
        Write-Host "==> Finished Winget Repair"
        Set-o9Taskbaritem -state "None" -overlay "checkmark"
    }

}

