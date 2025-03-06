<#
.SYNOPSIS
    Retrieves help documentation for all commands
.DESCRIPTION
    This function extracts each command from a given pipeline and retrieves its help text.
    Works for PowerShell cmdlets, functions, and external applications.
.PARAMETER Command
    The pipeline or standalone command to retrieve help for.
.EXAMPLE
    Get-CommandHelpText "Get-Process | Select-Object"
    # Returns help for both Get-Process and Select-Object.
.EXAMPLE
    Get-CommandHelpText "grep -r 'test' ."
    # Returns help for 'grep' if available.
.NOTES
    - Uses `Get-Help` for PowerShell commands.
    - Uses `--help` or `-h` for external applications.
#>
function Get-CommandHelpText(
    [Parameter(Mandatory)]
    [string] $Command
) {
    if (-not $Command) {
        return @("No command provided.")
    }

    # Split on pipeline (`|` and `||`), ensuring robust splitting
    $Commands = $Command -split '\s*\|\|?\s*'

    return $Commands | ForEach-Object {
        $Cmd = $_.Trim()
        $CommandInfo = Get-Command $Cmd -ErrorAction SilentlyContinue

        if ($CommandInfo -and $CommandInfo.CommandType -in @('Cmdlet', 'Function')) {
            try {
                return Get-Help $Cmd -Full -ErrorAction SilentlyContinue | Out-String
            }
            catch {
                return "Help unavailable for PowerShell command: $Cmd"
            }
        }
        elseif ($CommandInfo -and ($CommandInfo.CommandType -eq 'Application' -or $CommandInfo.Source)) {
            try {
                if (Test-Path (Get-Command $Cmd).Source) {
                    $HelpText = & $Cmd --help 2>&1 | Out-String
                    if (-not $HelpText) { $HelpText = & $Cmd -h 2>&1 | Out-String }
                    return $HelpText.Trim() -ne "" ? $HelpText : "No help available for $Cmd."
                }
            }
            catch {
                return "Failed to retrieve help for external command: $Cmd"
            }
        }
        else {
            return "Unknown command: $Cmd"
        }
    }
}
