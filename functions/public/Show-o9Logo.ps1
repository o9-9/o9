Function Show-o9Logo {
    <#
        .SYNOPSIS
            Displays the o9 logo in ASCII art.
        .DESCRIPTION
            This function displays the o9 logo in ASCII art format.
        .PARAMETER None
            No parameters are required for this function.
        .EXAMPLE
            Show-o9Logo
            Prints the o9 logo in ASCII art format to the console.
    #>

    $asciiArt = @"
                         999999999
                       99:::::::::99
                     99:::::::::::::99
                    9::::::99999::::::9
   ooooooooooo      9:::::9     9:::::9
 oo:::::::::::oo    9:::::9     9:::::9
o:::::::::::::::o    9:::::99999::::::9
o:::::ooooo:::::o     99::::::::::::::9
o::::o     o::::o       99999::::::::9
o::::o     o::::o            9::::::9
o::::o     o::::o           9::::::9
o::::o     o::::o          9::::::9
o:::::ooooo:::::o         9::::::9
o:::::::::::::::o        9::::::9
 oo:::::::::::oo        9::::::9
   ooooooooooo         99999999

========================================
"@

    Write-Host $asciiArt
}
