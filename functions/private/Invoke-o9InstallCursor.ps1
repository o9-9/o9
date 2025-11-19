function Invoke-o9InstallCursor {
    param(
        [string]$RepoUrl = "https://raw.githubusercontent.com/o9-9/cursor-setup/main",
        [string]$FontName = "fonts",
        [string]$FontDisplayName = "JetBrains Mono",
        [string]$FontVersion = "1"
    )

    # Install Cursor
    winget install --id Anysphere.Cursor --scope machine --accept-package-agreements --accept-source-agreements

    # Configure Cursor Settings
    $CursorUserPath = "$env:APPDATA\Cursor\User"
    if (!(Test-Path $CursorUserPath)) {
        New-Item -ItemType Directory -Path $CursorUserPath -Force
    }

    # Download configuration files
    Invoke-WebRequest -Uri "$RepoUrl/settings.json" -OutFile "$CursorUserPath\settings.json"
    Invoke-WebRequest -Uri "$RepoUrl/keybindings.json" -OutFile "$CursorUserPath\keybindings.json"

    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    # Install Extensions
    $extensionsJson = "$env:TEMP\extensions.json"
    try {
        Invoke-WebRequest -Uri "$RepoUrl/extensions.json" -OutFile $extensionsJson -ErrorAction SilentlyContinue
        $extensions = (Get-Content $extensionsJson | ConvertFrom-Json).extensions
        $extensions | ForEach-Object {
            cursor --install-extension $_ --force
        }
    }
    catch {
        Write-Warning "Failed to install extensions: $_"
    }
    finally {
        Remove-Item $extensionsJson -ErrorAction SilentlyContinue
    }

    # Add Cursor to Context Menu
    $PATH = "$env:PROGRAMFILES\cursor\Cursor.exe"
    REG ADD "HKEY_CLASSES_ROOT\*\shell\Cursor"         /ve       /t REG_EXPAND_SZ /d "Edit with Cursor"   /f
    REG ADD "HKEY_CLASSES_ROOT\*\shell\Cursor"         /v "Icon" /t REG_EXPAND_SZ /d "$PATH"            /f
    REG ADD "HKEY_CLASSES_ROOT\*\shell\Cursor\command" /ve       /t REG_EXPAND_SZ /d """$PATH"" ""%1""" /f
    REG ADD "HKEY_CLASSES_ROOT\Directory\shell\Cursor"         /ve       /t REG_EXPAND_SZ /d "Edit with Cursor"   /f
    REG ADD "HKEY_CLASSES_ROOT\Directory\shell\Cursor"         /v "Icon" /t REG_EXPAND_SZ /d "$PATH"            /f
    REG ADD "HKEY_CLASSES_ROOT\Directory\shell\Cursor\command" /ve       /t REG_EXPAND_SZ /d """$PATH"" ""%V""" /f

    # Install o9 Theme
    Invoke-WebRequest "$RepoUrl/archive/o9-theme.zip" -OutFile "$env:TEMP\o9-theme.zip" -ErrorAction SilentlyContinue
    Expand-Archive "$env:TEMP\o9-theme.zip" -DestinationPath "$env:PROGRAMFILES\cursor\resources\app\extensions" -Force
    Remove-Item "$env:TEMP\o9-theme.zip" -ErrorAction SilentlyContinue

    # Install Fonts
    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
        if ($fontFamilies -notcontains "${FontDisplayName}") {
            $fontZipUrl = "https://github.com/o9-9/cursor-setup/releases/download/${FontVersion}/${FontName}.zip"
            $zipFilePath = "$env:TEMP\${FontName}.zip"
            $extractPath = "$env:TEMP\${FontName}"

            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFileAsync((New-Object System.Uri($fontZipUrl)), $zipFilePath)

            while ($webClient.IsBusy) {
                Start-Sleep -Seconds 2
            }
            Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
            $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
            Get-ChildItem -Path $extractPath -Recurse -Filter "*.ttf" | ForEach-Object {
                If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
                    $destination.CopyHere($_.FullName, 0x10)
                }
            }
            Remove-Item -Path $extractPath -Recurse -Force
            Remove-Item -Path $zipFilePath -Force
        }
    }
    catch {
        Write-Warning "Failed to install font: $_"
    }
}
