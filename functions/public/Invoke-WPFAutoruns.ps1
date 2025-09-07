function Invoke-WPFAutoruns {
    <#
    .SYNOPSIS
        Downloads and runs Autorun
    #>
    try {
        $Autoruns_zip = "$ENV:temp\Autoruns.zip"
        $Autoruns_folder = "$ENV:temp\Autoruns"
        $Autoruns_exe = "$Autoruns_folder\Autoruns64.exe"
        $Initial_ProgressPreference = $ProgressPreference
        $ProgressPreference = "SilentlyContinue" # Disables the Progress Bar to drasticly speed up Invoke-WebRequest
        Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Autoruns.zip" -OutFile $Autoruns_zip
        Expand-Archive -Path $Autoruns_zip -DestinationPath $Autoruns_folder -Force
        Write-Host "Starting Autoruns ..."
        Start-Process $Autoruns_exe
    } catch {
        Write-Host "Error Downloading and Running Autoruns64" -ForegroundColor Red
    }
    finally {
        $ProgressPreference = $Initial_ProgressPreference

        if (Test-Path $Autoruns_zip) {
            Remove-Item $Autoruns_zip -Force
        }
    }
}
