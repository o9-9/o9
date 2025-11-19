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
                                              ::=
                                         :::::==
                                     :::::::-===
                                  ::::::::-====
                               :::::::::-=====
                             ::::::::::======
                           ::::::::::=======
                         ::::::::::========
                       ::::::::::=========
                      :::::::::-=========
                    :::::::::-=========
            %%%%   :::::::::==========
           %%%%%%+::::::::==========
             %%%%%#:::::==========
               %%%%%#:==========
              #**%%%%%#=======
            %%%%%%%%%%%%*==
          *+++++++**#%%%%%%
         %%%%%#*++++* %%%%%%
       ++*#%%%%%%%%     %%%%
   %%%%#*+++++++*
 %%%%%%%%%%%%##
%%%%%%%%%%%%%%
%%%%%%%%%%%#
%%%%%%%%%%%
  %%%%%%%%
"@

    Write-Host $asciiArt
}
