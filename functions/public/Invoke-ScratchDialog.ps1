
function Invoke-ScratchDialog {

    <#

    .SYNOPSIS
        Enable Editable Text box Alternate Scratch path

    .PARAMETER Button
    #>
    $sync.WPFo99ISOScratchDir.IsChecked


    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $Dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $Dialog.SelectedPath =          $sync.o99ScratchDirBox.Text
    $Dialog.ShowDialog()
    $filePath = $Dialog.SelectedPath
        Write-Host "No ISO is chosen+  $filePath"

    if ([string]::IsNullOrEmpty($filePath)) {
        Write-Host "No Folder had chosen"
        return
    }

       $sync.o99ScratchDirBox.Text =  Join-Path $filePath "\"

}

