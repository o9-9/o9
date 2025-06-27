function Toggle-o99Panel {
    <#
    .SYNOPSIS
    Toggles the visibility of the o99 options and ISO panels in the GUI.
    .DESCRIPTION
    This function toggles the visibility of the o99 options and ISO panels in the GUI.
    .PARAMETER o99OptionsPanel
    The panel containing o99 options.
    .PARAMETER o99ISOPanel
    The panel containing the o99 ISO options.
    .EXAMPLE
    Toggle-o99Panel 1
    #>
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet(1, 2)]
        [int]$PanelNumber
    )

    if ($PanelNumber -eq 1) {
        $sync.o99ISOPanel.Visibility = 'Visible'
        $sync.o99OptionsPanel.Visibility = 'Collapsed'

    } elseif ($PanelNumber -eq 2) {
        $sync.o99OptionsPanel.Visibility = 'Visible'
        $sync.o99ISOPanel.Visibility = 'Collapsed'
    }
}

