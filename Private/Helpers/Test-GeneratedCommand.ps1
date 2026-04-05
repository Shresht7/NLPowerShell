<#
.SYNOPSIS
    Validates that all commands in a generated script block exist.
.DESCRIPTION
    Uses the AST parser to find all command names and verifies them with Get-Command.
.PARAMETER Script
    The generated PowerShell command string to validate.
.OUTPUTS
    An array of command names that were not found on the local system.
#>
function Test-GeneratedCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Script
    )

    if ([string]::IsNullOrWhiteSpace($Script)) { return @() }

    # Parse the generated script
    $Errors = $null
    $Tokens = $null
    $AST = [System.Management.Automation.Language.Parser]::ParseInput($Script, [ref]$Tokens, [ref]$Errors)

    # Extract all CommandAst nodes
    $CommandNodes = $AST.FindAll({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $true)
    
    # Get unique command names
    $CommandNames = $CommandNodes | ForEach-Object { $_.GetCommandName() } | Select-Object -Unique | Where-Object { $_ }

    # Filter for missing commands
    $Missing = @()
    foreach ($Cmd in $CommandNames) {
        # Check if it exists (Cmdlet, Function, Alias, or Application)
        if (-not (Get-Command $Cmd -ErrorAction SilentlyContinue)) {
            $Missing += $Cmd
        }
    }

    return $Missing
}
