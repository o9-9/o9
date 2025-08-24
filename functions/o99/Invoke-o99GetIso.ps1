function Invoke-o99GetIso {
    <#
    .DESCRIPTION
    Function to get the path to Iso file for o99, unpack that isom=, read basic information and populate the UI Options
    #>

    Write-Host "Invoking WPFGetIso"

    if($sync.ProcessRunning) {
        $msg = "GetIso process is currently running."
        [System.Windows.MessageBox]::Show($msg, "o9", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }

    # Provide immediate feedback to user
    Invoke-o99BusyInfo -action "wip" -message "Initializing o99 process..." -interactive $false

    Write-Host "                         999999999               999999999      "
    Write-Host "                       99:::::::::99           99:::::::::99    "
    Write-Host "                     99:::::::::::::99       99:::::::::::::99  "
    Write-Host "                    9::::::99999::::::9     9::::::99999::::::9 "
    Write-Host "   ooooooooooo      9:::::9     9:::::9     9:::::9     9:::::9 "
    Write-Host " oo:::::::::::oo    9:::::9     9:::::9     9:::::9     9:::::9 "
    Write-Host "o:::::::::::::::o    9:::::99999::::::9     9::::::99999::::::9 "
    Write-Host "o:::::ooooo:::::o     99::::::::::::::9      99::::::::::::::9  "
    Write-Host "o::::o     o::::o       99999::::::::9         99999::::::::9   "
    Write-Host "o::::o     o::::o            9::::::9              9::::::9     "
    Write-Host "o::::o     o::::o           9::::::9              9::::::9      "
    Write-Host "o::::o     o::::o          9::::::9              9::::::9       "
    Write-Host "o:::::ooooo:::::o         9::::::9              9::::::9        "
    Write-Host "o:::::::::::::::o        9::::::9              9::::::9         "
    Write-Host " oo:::::::::::oo        9::::::9              9::::::9          "
    Write-Host "   ooooooooooo         99999999              99999999           "

    if ($sync["ISOmanual"].IsChecked) {
        # Open file dialog to let user choose the ISO file
        Invoke-o99BusyInfo -action "wip" -message "Please select an ISO file..." -interactive $true
        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.initialDirectory = $initialDirectory
        $openFileDialog.filter = "ISO files (*.iso)| *.iso"
        $openFileDialog.ShowDialog() | Out-Null
        $filePath = $openFileDialog.FileName

        if ([string]::IsNullOrEmpty($filePath)) {
            Write-Host "No ISO is chosen"
            Invoke-o99BusyInfo -action "hide" -message " "
            return
        }

    } elseif ($sync["ISOdownloader"].IsChecked) {
        # Create folder browsers for user-specified locations
        Invoke-o99BusyInfo -action "wip" -message "Please select download location..." -interactive $true
        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
        $isoDownloaderFBD = New-Object System.Windows.Forms.FolderBrowserDialog
        $isoDownloaderFBD.Description = "Please specify the path to download the ISO file to:"
        $isoDownloaderFBD.ShowNewFolderButton = $true
        if ($isoDownloaderFBD.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK)
        {
            Invoke-o99BusyInfo -action "hide" -message " "
            return
        }

        Set-o9Taskbaritem -state "Indeterminate" -overlay "logo"
        Invoke-o99BusyInfo -action "wip" -message "Preparing to download ISO..." -interactive $false

        # Grab the location of the selected path
        $targetFolder = $isoDownloaderFBD.SelectedPath

        # Auto download newest ISO
        # Credit: https://github.com/pbatard/Fido
        $fidopath = "$env:temp\Fido.ps1"
        $originalLocation = $PSScriptRoot

        Invoke-o99BusyInfo -action "wip" -message "Downloading Fido script..." -interactive $false
        Invoke-WebRequest "https://github.com/pbatard/Fido/raw/master/Fido.ps1" -OutFile $fidopath

        Set-Location -Path $env:temp
        # Detect if the first option ("System language") has been selected and get a Fido-approved language from the current culture
        $lang = if ($sync["ISOLanguage"].SelectedIndex -eq 0) {
            o99-GetLangFromCulture -langName (Get-Culture).Name
        } else {
            $sync["ISOLanguage"].SelectedItem
        }

        Invoke-o99BusyInfo -action "wip" -message "Downloading Windows ISO... (This may take a long time)" -interactive $false
        & $fidopath -Win 'Windows 11' -Rel $sync["ISORelease"].SelectedItem -Arch "x64" -Lang $lang -Ed "Windows 11 Home/Pro/Edu"
        if (-not $?)
        {
            Write-Host "Could not download the ISO file. Look at the output of the console for more information."
            $msg = "The ISO file could not be downloaded"
            Invoke-o99BusyInfo -action "warning" -message $msg
            Set-o9Taskbaritem -state "Error" -value 1 -overlay "warning"
            [System.Windows.MessageBox]::Show($msg, "o9", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            return
        }
        Set-Location $originalLocation
        # Use the FullName property to only grab the file names. Using this property is necessary as, without it, you're passing the usual output of Get-ChildItem
        # to the variable, and let's be honest, that does NOT exist in the file system
        $filePath = (Get-ChildItem -Path "$env:temp" -Filter "Win11*.iso").FullName | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        $fileName = [IO.Path]::GetFileName("$filePath")

        if (($targetFolder -ne "") -and (Test-Path "$targetFolder"))
        {
            try
            {
                # "Let it download to $env:TEMP and then we **move** it to the file path." -
                $destinationFilePath = "$targetFolder\$fileName"
                Write-Host "Moving ISO file. Please wait..."
                Move-Item -Path "$filePath" -Destination "$destinationFilePath" -Force
                $filePath = $destinationFilePath
            }
            catch
            {
                $msg = "Unable to move the ISO file to the location you specified. The downloaded ISO is in the `"$env:TEMP`" folder"
                Write-Host $msg
                Write-Host "Error information: $($_.Exception.Message)" -ForegroundColor Yellow
                Invoke-o99BusyInfo -action "warning" -message $msg
                return
            }
        }
    }

    Write-Host "File path $($filePath)"
    if (-not (Test-Path -Path "$filePath" -PathType Leaf)) {
        $msg = "File you've chosen doesn't exist"
        Invoke-o99BusyInfo -action "warning" -message $msg
        [System.Windows.MessageBox]::Show($msg, "o9", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        return
    }

    Set-o9Taskbaritem -state "Indeterminate" -overlay "logo"
    Invoke-o99BusyInfo -action "wip" -message "Checking system requirements..." -interactive $false

    $oscdimgPath = Join-Path $env:TEMP 'oscdimg.exe'
    $oscdImgFound = [bool] (Get-Command -ErrorAction Ignore -Type Application oscdimg.exe) -or (Test-Path $oscdimgPath -PathType Leaf)
    Write-Host "oscdimg.exe on system: $oscdImgFound"

    if (!$oscdImgFound) {
        $downloadFromGitHub = $sync.WPFo99DownloadFromGitHub.IsChecked

        if (!$downloadFromGitHub) {
            # only show the message to people who did check the box to download from github, if you check the box
            # you consent to downloading it, no need to show extra dialogs
            [System.Windows.MessageBox]::Show("oscdimge.exe is not found on the system, o9 will now attempt do download and install it using choco. This might take a long time.")
            # the step below needs choco to download oscdimg
            # Install Choco if not already present
            Install-o9Choco
            $chocoFound = [bool] (Get-Command -ErrorAction Ignore -Type Application choco)
            Write-Host "choco on system: $chocoFound"
            if (!$chocoFound) {
                [System.Windows.MessageBox]::Show("choco.exe is not found on the system, you need choco to download oscdimg.exe")
                return
            }

            Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "choco install windows-adk-oscdimg"
            $msg = "oscdimg is installed, now close, reopen PowerShell terminal and re-launch o9.ps1"
            Invoke-o99BusyInfo -action "done" -message $msg        # We set it to done because it immediately returns from this function
            [System.Windows.MessageBox]::Show($msg)
            return
        } else {
            [System.Windows.MessageBox]::Show("oscdimge.exe is not found on the system, o9 will now attempt do download and install it from github. This might take a long time.")
            Invoke-o99BusyInfo -action "wip" -message "Downloading oscdimg.exe..." -interactive $false
            o99-GetOscdimg -oscdimgPath $oscdimgPath
            $oscdImgFound = Test-Path $oscdimgPath -PathType Leaf
            if (!$oscdImgFound) {
                $msg = "oscdimg was not downloaded can not proceed"
                Invoke-o99BusyInfo -action "warning" -message $msg
                [System.Windows.MessageBox]::Show($msg, "o9", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
                return
            } else {
                Write-Host "oscdimg.exe was successfully downloaded from github"
            }
        }
    }

    Invoke-o99BusyInfo -action "wip" -message "Checking disk space..." -interactive $false

    # Detect the file size of the ISO and compare it with the free space of the system drive
    $isoSize = (Get-Item -Path "$filePath").Length
    Write-Debug "Size of ISO file: $($isoSize) bytes"
    # Use this procedure to get the free space of the drive depending on where the user profile folder is stored.
    # This is done to guarantee a dynamic solution, as the installation drive may be mounted to a letter different than C
    $driveSpace = (Get-Volume -DriveLetter ([IO.Path]::GetPathRoot([Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)).Replace(":\", "").Trim())).SizeRemaining
    Write-Debug "Free space on installation drive: $($driveSpace) bytes"
    if ($driveSpace -lt ($isoSize * 2)) {
        # It's not critical and we _may_ continue. Output a warning
        Write-Warning "You may not have enough space for this operation. Proceed at your own risk."
    }
    elseif ($driveSpace -lt $isoSize) {
        # It's critical and we can't continue. Output an error
        $msg = "You don't have enough space for this operation. You need at least $([Math]::Round(($isoSize / ([Math]::Pow(1024, 2))) * 2, 2)) MB of free space to copy the ISO files to a temp directory and to be able to perform additional operations."
        Write-Host $msg
        Set-o9Taskbaritem -state "Error" -value 1 -overlay "warning"
        Invoke-o99BusyInfo -action "warning" -message $msg
        return
    } else {
        Write-Host "You have enough space for this operation."
    }

    try {
        Invoke-o99BusyInfo -action "wip" -message "Mounting ISO file..." -interactive $false
        Write-Host "Mounting Iso. Please wait."
        $mountedISO = Mount-DiskImage -PassThru "$filePath"
        Write-Host "Done mounting Iso `"$($mountedISO.ImagePath)`""
        $driveLetter = (Get-Volume -DiskImage $mountedISO).DriveLetter
        Write-Host "Iso mounted to '$driveLetter'"
    } catch {
        # @o9-9  please copy this wiki and change the link below to your copy of the wiki
        $msg = "Failed to mount the image. Error: $($_.Exception.Message)"
        Write-Error $msg
        Write-Error "This is NOT o9's problem, your ISO might be corrupt, or there is a problem on the system"
        Write-Host "Please refer to this wiki for more details: https://o9-9.github.io/o9/KnownIssues/#troubleshoot-errors-during-o99-usage" -ForegroundColor Red
        Set-o9Taskbaritem -state "Error" -value 1 -overlay "warning"
        Invoke-o99BusyInfo -action "warning" -message $msg
        return
    }
    # storing off values in hidden fields for further steps
    # there is probably a better way of doing this, I don't have time to figure this out
    $sync.o99IsoDrive.Text = $driveLetter

    $mountedISOPath = (Split-Path -Path "$filePath")
     if ($sync.o99ScratchDirBox.Text.Trim() -eq "Scratch") {
        $sync.o99ScratchDirBox.Text =""
    }

    $UseISOScratchDir = $sync.WPFo99ISOScratchDir.IsChecked

    if ($UseISOScratchDir) {
        $sync.o99ScratchDirBox.Text=$mountedISOPath
    }

    if( -Not $sync.o99ScratchDirBox.Text.EndsWith('\') -And  $sync.o99ScratchDirBox.Text.Length -gt 1) {

         $sync.o99ScratchDirBox.Text = Join-Path   $sync.o99ScratchDirBox.Text.Trim() '\'

    }

    # Detect if the folders already exist and remove them
    if (($sync.o99MountDir.Text -ne "") -and (Test-Path -Path $sync.o99MountDir.Text)) {
        try {
            Write-Host "Deleting temporary files from previous run. Please wait..."
            Remove-Item -Path $sync.o99MountDir.Text -Recurse -Force
            Remove-Item -Path $sync.o99ScratchDir.Text -Recurse -Force
        } catch {
            Write-Host "Could not delete temporary files. You need to delete those manually."
        }
    }

    Write-Host "Setting up mount dir and scratch dirs"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $randomNumber = Get-Random -Minimum 1 -Maximum 9999
    $randomo99 = "o99_${timestamp}_${randomNumber}"
    $randomo99Scratch = "o99Scratch_${timestamp}_${randomNumber}"
    $sync.BusyText.Text=" - Mounting"
    Write-Host "Mounting Iso. Please wait."
    if ($sync.o99ScratchDirBox.Text -eq "") {
        $mountDir = Join-Path $env:TEMP $randomo99
        $scratchDir = Join-Path $env:TEMP $randomo99Scratch
    } else {
        $scratchDir = $sync.o99ScratchDirBox.Text+"Scratch"
        $mountDir = $sync.o99ScratchDirBox.Text+"micro"
    }

    $sync.o99MountDir.Text = $mountDir
    $sync.o99ScratchDir.Text = $scratchDir
    Write-Host "Done setting up mount dir and scratch dirs"
    Write-Host "Scratch dir is $scratchDir"
    Write-Host "Image dir is $mountDir"

    try {

        #$data = @($driveLetter, $filePath)
        Invoke-o99BusyInfo -action "wip" -message "Creating directories..." -interactive $false
        New-Item -ItemType Directory -Force -Path "$($mountDir)" | Out-Null
        New-Item -ItemType Directory -Force -Path "$($scratchDir)" | Out-Null

        Invoke-o99BusyInfo -action "wip" -message "Copying Windows files... (This may take several minutes)" -interactive $false
        Write-Host "Copying Windows image. This will take awhile, please don't use UI or cancel this step!"

        # xcopy we can verify files and also not copy files that already exist, but hard to measure
        # xcopy.exe /E /I /H /R /Y /J $DriveLetter":" $mountDir >$null
        $totalTime = Measure-Command {
            Copy-Files "$($driveLetter):" "$mountDir" -Recurse -Force
            # Force UI update during long operation
            [System.Windows.Forms.Application]::DoEvents()
        }
        Write-Host "Copy complete! Total Time: $($totalTime.Minutes) minutes, $($totalTime.Seconds) seconds"

        Invoke-o99BusyInfo -action "wip" -message "Processing Windows image..." -interactive $false
        $wimFile = "$mountDir\sources\install.wim"
        Write-Host "Getting image information $wimFile"

        if ((-not (Test-Path -Path "$wimFile" -PathType Leaf)) -and (-not (Test-Path -Path "$($wimFile.Replace(".wim", ".esd").Trim())" -PathType Leaf))) {
            $msg = "Neither install.wim nor install.esd exist in the image, this could happen if you use unofficial Windows images. Please don't use shady images from the internet."
            Write-Host "$($msg) Only use official images. Here are instructions how to download ISO images if the Microsoft website is not showing the link to download and ISO. https://www.techrepublic.com/article/how-to-download-a-windows-10-iso-file-without-using-the-media-creation-tool/"
            Invoke-o99BusyInfo -action "warning" -message $msg
            Set-o9Taskbaritem -state "Error" -value 1 -overlay "warning"
            [System.Windows.MessageBox]::Show($msg, "o9", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            throw
        }
        elseif ((-not (Test-Path -Path $wimFile -PathType Leaf)) -and (Test-Path -Path $wimFile.Replace(".wim", ".esd").Trim() -PathType Leaf)) {
            Write-Host "Install.esd found on the image. It needs to be converted to a WIM file in order to begin processing"
            $wimFile = $wimFile.Replace(".wim", ".esd").Trim()
        }
        $sync.o99WindowsFlavors.Items.Clear()
        Get-WindowsImage -ImagePath $wimFile | ForEach-Object {
            $imageIdx = $_.ImageIndex
            $imageName = $_.ImageName
            $sync.o99WindowsFlavors.Items.Add("$imageIdx : $imageName")
        }
        [System.Windows.Forms.Application]::DoEvents()

        $sync.o99WindowsFlavors.SelectedIndex = 0
        Write-Host "Finding suitable Pro edition. This can take some time. Do note that this is an automatic process that might not select the edition you want."
        Invoke-o99BusyInfo -action "wip" -message "Finding suitable Pro edition..." -interactive $false

        Get-WindowsImage -ImagePath $wimFile | ForEach-Object {
            if ((Get-WindowsImage -ImagePath $wimFile -Index $_.ImageIndex).EditionId -eq "Professional") {
                # We have found the Pro edition
                $sync.o99WindowsFlavors.SelectedIndex = $_.ImageIndex - 1
            }
            # Allow UI updates during this loop
            [System.Windows.Forms.Application]::DoEvents()
        }

        Get-Volume $driveLetter | Get-DiskImage | Dismount-DiskImage
        Write-Host "Selected value '$($sync.o99WindowsFlavors.SelectedValue)'....."

        Toggle-o99Panel 2

    } catch {
        Write-Host "Dismounting bad image..."
        Get-Volume $driveLetter | Get-DiskImage | Dismount-DiskImage
        Remove-Item -Recurse -Force "$($scratchDir)"
        Remove-Item -Recurse -Force "$($mountDir)"
        Invoke-o99BusyInfo -action "warning" -message "Failed to read and unpack ISO"
        Set-o9Taskbaritem -state "Error" -value 1 -overlay "warning"

    }

    Write-Host "Done reading and unpacking ISO"
    Write-Host ""
    Write-Host "*********************************"
    Write-Host "Check the UI for further steps!!!"

    Invoke-o99BusyInfo -action "done" -message "Done! Proceed with customization."
    $sync.ProcessRunning = $false
    Set-o9Taskbaritem -state "None" -overlay "checkmark"
}
