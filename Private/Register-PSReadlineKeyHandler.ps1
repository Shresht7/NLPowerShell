function Register-PSReadlineKeyHandler([Parameter(Mandatory)][string] $KeyBind) {
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

            # Local helper to handle error display
            $HandleError = {
                param($OriginalLine, $ErrorObj)
                $Msg = if ($ErrorObj.Exception) { $ErrorObj.Exception.Message } else { $ErrorObj.ToString() }
                $ShortMsg = $Msg.Split("`n")[0].Trim() # Keep only the first line
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$OriginalLine # [Error: $ShortMsg]")
            }

            # Check if the input contains a comment ("#")
            if ($Line -match "^(?<Command>.*?)\s*#\s*(?<Comment>.*)$") {
                $CommandPart = $matches['Command'].Trim()
                $CommentPart = $matches['Comment'].Trim()

                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" [Generating Command...]")

                # Call AI function for command generation
                try {
                    $SuggestedCommand = Get-NLPowerShellCommand -Comment $CommentPart -Command $CommandPart -ErrorAction Stop

                    if ($null -eq $SuggestedCommand) {
                        &$HandleError -OriginalLine $Line -ErrorObj "No response from AI"
                        return
                    }

                    # Replace input with generated command and keep the original comment
                    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($SuggestedCommand -join "`n"))
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("  # $CommentPart")
                }
                catch {
                    &$HandleError -OriginalLine $Line -ErrorObj $_
                }
            }
            
            # If no comment is found, generate an explanation
            else {
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("  # [Generating Explanation...]")

                # Call AI function for explanation
                try {
                    $SuggestedExplanation = Get-NLPowerShellExplanation -Line $Line -ErrorAction Stop

                    if ($null -eq $SuggestedExplanation) {
                        &$HandleError -OriginalLine $Line -ErrorObj "No response from AI"
                        return
                    }

                    # Append explanation as a comment
                    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(("  # " + ($SuggestedExplanation -join "`n # ")))
                }
                catch {
                    &$HandleError -OriginalLine $Line -ErrorObj $_
                }
            }
        }
    }
    catch {
        Write-Error "Failed to register key binding ($KeyBind). Error: $_"
    }
}
