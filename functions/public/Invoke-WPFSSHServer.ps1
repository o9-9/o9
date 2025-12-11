function Invoke-WPFSSHServer {
    <#

    .SYNOPSIS
        Invokes the OpenSSH Server install in a runspace

  #>

    Invoke-WPFRunspace -DebugPreference $DebugPreference -ScriptBlock {

        Invoke-o9SSHServer

        Write-Host "===========================================" -ForegroundColor Cyan
        Write-Host "---       OpenSSH Server installed!     ---"-ForegroundColor Cyan
        Write-Host "===========================================" -ForegroundColor Cyan
    }
}

