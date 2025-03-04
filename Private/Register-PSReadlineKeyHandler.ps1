<#
.SYNOPSIS
    Performs the PSReadLine key-handler registration
#>
function Register-PSSReadlineKeyHandler() {
    Set-PSReadLineKeyHandler -Key Ctrl+Insert `
        -BriefDescription "Use Natural Language to interact with PowerShell" `
        -ScriptBlock {
        param ($Key, $Arg)

        # Instantiate $Line and $Cursor
        $Line = $null
        $Cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)

        # If the line is a comment ...
        if ($Line.StartsWith("#")) {
            # ... get response from the Get-NLPowerShellCommand function
            $SuggestedCommand = Get-NLPowerShellCommand -Line $Line
            if ($null -eq $SuggestedCommand) { return }
    
            # Delete the entire line
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
            foreach ($Str in $SuggestedCommand) {
                if ($null -ne $Str -and $Str -ne "") {
                    # Append the generated command
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Str)
                }
            }
            # Readd the original comment
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    $Line")
        }

        # If the line is not a command and an explanation is required ...
        else {
            # ... get response from the Get-NLPowerShellExplanation function
            $SuggestedExplanation = Get-NLPowerShellExplanation -Line $Line
            if ($null -eq $SuggestedExplanation) { return }

            # Append an explanation at the end as a comment
            foreach ($Str in $SuggestedExplanation) {
                if ($null -ne $Str -and $Str -ne "") {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    # $Str")
                }
            }
        }

    }
}
