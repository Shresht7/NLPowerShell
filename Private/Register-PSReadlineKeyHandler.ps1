<#
.SYNOPSIS
    Registers a PSReadLine key handler to interact with Natural Language in PowerShell.
.DESCRIPTION
    This function binds a specified key to a script block that processes user input.
    - If input starts with `#`, it is treated as a comment and converted into a command.
    - Otherwise, an explanation of the command is generated.
.PARAMETER KeyBind
    The key binding that triggers the handler. Example: "Ctrl+Insert".
    Must be a valid PSReadLine key.
.EXAMPLE
    Register-PSSReadlineKeyHandler -KeyBind "Ctrl+Insert"
#>
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

            # Process comments: Convert NL prompt into a command
            if ($Line.StartsWith("#")) {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" [Processing...]")
                
                # Call AI function
                $SuggestedCommand = Get-NLPowerShellCommand -Line $Line

                # Restore original line if no response
                if ($null -eq $SuggestedCommand) {
                    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                    return
                }

                # Replace input with the generated command
                [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($SuggestedCommand -join "`n"))
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    $Line")
            }

            # Process commands: Generate an explanation
            else {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    # [Processing...]")

                # Call AI function
                $SuggestedExplanation = Get-NLPowerShellExplanation -Line $Line

                # Restore original line if no response
                if ($null -eq $SuggestedExplanation) {
                    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                    return
                }

                # Append explanation as a comment
                [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Line)
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(("    # " + ($SuggestedExplanation -join "`n    # ")))
            }
        }
    }
    catch {
        Write-Error "Failed to register key binding ($KeyBind). Error: $_"
    }
}
