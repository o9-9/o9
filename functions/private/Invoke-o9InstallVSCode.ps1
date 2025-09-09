function Invoke-o9InstallVSCode {
    Write-Host "`n[1/5] Installing VS Code..." -ForegroundColor Cyan
    winget install --id Microsoft.VisualStudioCode --scope machine --accept-package-agreements --accept-source-agreements
    Write-Host "✔ VS Code Installed." -ForegroundColor Green

    Write-Host "`n[2/5] Installing GitHub Repository..." -ForegroundColor Cyan
    $repoUrl = "https://raw.githubusercontent.com/o9-9/vscode-setup/main"
    $vsCodeUserPath = "$env:APPDATA\Code\User"
    Write-Host "✔ GitHub Repository Installed." -ForegroundColor Green

    if (!(Test-Path $vsCodeUserPath)) {
        New-Item -ItemType Directory -Path $vsCodeUserPath -Force
        Write-Host "✔ Created VS Code Settings Directory." -ForegroundColor Green
    }

    Invoke-WebRequest -Uri "$repoUrl/settings.json" -OutFile "$vsCodeUserPath\settings.json"
    Write-Host "✔ Copied Settings.json to VS Code." -ForegroundColor Green

    Invoke-WebRequest -Uri "$repoUrl/keybindings.json" -OutFile "$vsCodeUserPath\keybindings.json"
    Write-Host "✔ Copied Keybindings.json to VS Code." -ForegroundColor Green

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host "✔ Environment Variables Refreshed." -ForegroundColor Green

    Write-Host "`n[3/5] Installing Extensions..." -ForegroundColor Cyan
    $extensionsJson = "$env:TEMP\extensions.json"
    Invoke-WebRequest -Uri "$repoUrl/extensions.json" -OutFile $extensionsJson
    $extensions = (Get-Content $extensionsJson | ConvertFrom-Json).extensions
    $extensions | ForEach-Object {
        code --install-extension $_
        Write-Host "✔ Installed $_" -ForegroundColor Cyan
    }
    Remove-Item $extensionsJson

    Write-Host "`n[4/5] Adding VS Code to Context Menu..." -ForegroundColor Cyan
    $MultilineComment = @"
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shell\Open with VS Code]
@="Edit with VS Code"
"Icon"="C:\\Program Files\\Microsoft VS Code\\Code.exe,0"
[HKEY_CLASSES_ROOT\*\shell\Open with VS Code\command]
@="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%1\""

[HKEY_CLASSES_ROOT\Directory\shell\vscode]
@="Open Folder as VS Code Project"
"Icon"="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\",0"
[HKEY_CLASSES_ROOT\Directory\shell\vscode\command]
@="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%1\""

[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode]
@="Open Folder as VS Code Project"
"Icon"="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\",0"
[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode\command]
@="\"C:\\Program Files\\Microsoft VS Code\\Code.exe\" \"%V\""
"@
    $regFile = "$env:TEMP\VSCodeContextMenu.reg"
    Set-Content -Path $regFile -Value $MultilineComment -Force
    Regedit.exe /S $regFile

    Write-Host "✔ VS Code Context Menu Entries Added." -ForegroundColor Green

    Write-Host "`n[5/5] Configuration Complete." -ForegroundColor Green
}
