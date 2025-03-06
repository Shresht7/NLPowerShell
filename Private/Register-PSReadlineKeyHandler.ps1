function Register-PSSReadlineKeyHandler([Parameter(Mandatory)][string] $KeyBind) {
    # Validate that PSReadLine is available
    if (-not (Get-Module -Name PSReadLine -ListAvailable)) {
        Write-Error "PSReadLine module is not installed. This function requires PSReadLine."
        return
    }

    # Register the key handler
    try {
        Set-PSReadLineKeyHandler -Key $KeyBind `
            -BriefDescription "Use Natural Language to interact with PowerShell" `
            -ScriptBlock {
            param ($Key, $Arg)

            # Retrieve the current buffer state
            $Line = $null
            $Cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)

            # Exit early if input is empty
            if ([string]::IsNullOrWhiteSpace($Line)) {
                return
            }

            # Check if the input contains a comment ("#")
            if ($Line -match "^(?<Command>.*?)\s*#\s*(?<Comment>.*)$") {
                $CommandPart = $matches['Command'].Trim()
                $CommentPart = $matches['Comment'].Trim()

                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" [Generating Command...]")

                # Call AI function for command generation
                $SuggestedCommand = Get-NLPowerShellCommand -Line $CommentPart -Command $CommandPart

                # Restore original line if no response
                if ($null -eq $SuggestedCommand) {
                    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                    return
                }

                # Replace input with generated command and keep the original comment
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($SuggestedCommand -join "`n"))
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("  # $CommentPart")
            }
            
            # If no comment is found, generate an explanation
            else {
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("  # [Generating Explanation...]")

                # Call AI function for explanation
                $SuggestedExplanation = Get-NLPowerShellExplanation -Line $Line

                # Restore original line if no response
                if ($null -eq $SuggestedExplanation) {
                    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                    return
                }

                # Append explanation as a comment
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(("  # " + ($SuggestedExplanation -join "`n # ")))
            }
        }
    }
    catch {
        Write-Error "Failed to register key binding ($KeyBind). Error: $_"
    }
}
