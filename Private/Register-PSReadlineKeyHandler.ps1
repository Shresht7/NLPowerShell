<#
.SYNOPSIS
    Performs the PSReadLine key-handler registration
#>
function Register-PSSReadlineKeyHandler() {
    Set-PSReadLineKeyHandler -Key Ctrl+Insert `
        -BriefDescription "Use Natural Language to interact with PowerShell" `
        -ScriptBlock {
        param ($Key, $Arg)

        # Retrieve the current buffer state
        $Line = $null
        $Cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)

        # If the input is a comment then generate the command
        if ($Line.StartsWith("#")) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" [Processing...]")
            
            # Get the response from the Get-NLPowerShellCommand function
            $SuggestedCommand = Get-NLPowerShellCommand -Line $Line

            # If there was no response, restore the line
            if ($null -eq $SuggestedCommand) {
                [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                return
            }    
            # Otherwise, replace input with generated command + original comment
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($SuggestedCommand -join "`n"))
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    $Line")
        }

        # If the input is a command, generate an explanation
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    # [Processing...]")

            # Get response from the Get-NLPowerShellExplanation function
            $SuggestedExplanation = Get-NLPowerShellExplanation -Line $Line

            # If there was no response, then restore the line
            if ($null -eq $SuggestedExplanation) {
                [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                return
            }

            # Otherwise, append an explanation at the end as a comment
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(("    # " + ($SuggestedExplanation -join "`n    # ")))
        }

    }
}
