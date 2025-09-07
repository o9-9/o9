function Invoke-o9InstallTheme {
	param (
		[string]$ThemeUrl = "https://raw.githubusercontent.com/o9-9/o9-theme/main/o9-theme.zip",
		[string]$ZipPath = "$env:TEMP\o9-theme.zip",
		[string]$ExtractPath = "$env:TEMP\o9-theme",
		[string]$DestinationPath = "C:\Program Files\Microsoft VS Code\resources\app\extensions",
		[string]$SevenZipPath = "C:\Program Files\7-Zip\7z.exe"
	)

	Write-Host "`n[1/2] Downloading o9 Theme..." -ForegroundColor Cyan
	try {
		Invoke-WebRequest -Uri $ThemeUrl -OutFile $ZipPath -UseBasicParsing
		Write-Host "[OK] Downloaded: $ZipPath" -ForegroundColor Green
	}
 catch {
		Write-Error "Failed to download o9 Theme: $_"
		return
	}

	if (!(Test-Path $SevenZipPath)) {
		Write-Error "7-Zip not found at: $SevenZipPath"
		return
	}

	if (Test-Path $ExtractPath) {
		Remove-Item -Path $ExtractPath -Recurse -Force
	}

	try {
		& "$SevenZipPath" x $ZipPath -o"$ExtractPath" -y | Out-Null
		Write-Host "[OK] Extracted to: $ExtractPath" -ForegroundColor Green
	}
 catch {
		Write-Error "Extraction failed: $_"
		return
	}

	try {
		$folderName = Get-ChildItem -Path $ExtractPath | Where-Object { $_.PSIsContainer } | Select-Object -First 1
		$targetFolder = Join-Path -Path $DestinationPath -ChildPath $folderName.Name

		if (Test-Path $targetFolder) {
			Remove-Item -Path $targetFolder -Recurse -Force
		}

		Move-Item -Path $folderName.FullName -Destination $DestinationPath
		Write-Host "[OK] o9 Theme installed at: $targetFolder" -ForegroundColor Green
	}
 catch {
		Write-Error "Failed to move theme folder: $_"
		return
	}

	Write-Host "`n[2/2] Installation complete." -ForegroundColor Green
}
