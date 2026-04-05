<#
.SYNOPSIS
    Retrieves help documentation for all commands in a string.
.DESCRIPTION
    Uses the PowerShell AST parser to identify all command calls in the input string
    and retrieves their help documentation.
.PARAMETER Command
    The PowerShell script or command string to analyze.
#>
function Get-CommandHelpText(
    [Parameter(Mandatory)]
    [string] $Command
) {
    if ([string]::IsNullOrWhiteSpace($Command)) {
        return @()
    }

    # Parse the input string into an AST
    $Errors = $null
    $Tokens = $null
    $AST = [System.Management.Automation.Language.Parser]::ParseInput($Command, [ref]$Tokens, [ref]$Errors)

    # Extract all CommandAst nodes (actual command calls)
    $CommandNodes = $AST.FindAll({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $true)
    
    # Get unique command names
    $CommandNames = $CommandNodes | ForEach-Object { $_.GetCommandName() } | Select-Object -Unique | Where-Object { $_ }

    if ($null -eq $CommandNames) {
        return @()
    }

    return $CommandNames | ForEach-Object {
        $Cmd = $_
        $CommandInfo = Get-Command $Cmd -ErrorAction SilentlyContinue

        if ($CommandInfo) {
            # Use the resolved name for PowerShell commands
            $ResolvedName = $CommandInfo.Name

            if ($CommandInfo.CommandType -in @('Cmdlet', 'Function', 'Filter', 'Alias')) {
                try {
                    # Retrieve full help for PowerShell commands
                    $Help = Get-Help $ResolvedName -Full -ErrorAction SilentlyContinue | Out-String
                    if (-not [string]::IsNullOrWhiteSpace($Help)) {
                        return "--- Help for $ResolvedName ---`n$($Help.Trim())"
                    }
                }
                catch {}
            }
            elseif ($CommandInfo.CommandType -eq 'Application') {
                try {
                    # For external applications, attempt to get help via flags
                    # We redirect stderr to stdout to capture all output
                    $HelpText = & $Cmd --help 2>&1 | Out-String
                    if ([string]::IsNullOrWhiteSpace($HelpText)) { 
                        $HelpText = & $Cmd -h 2>&1 | Out-String 
                    }
                    
                    if (-not [string]::IsNullOrWhiteSpace($HelpText)) {
                        return "--- Help for $Cmd (External) ---`n$($HelpText.Trim())"
                    }
                }
                catch {}
            }
        }
        
        return "No detailed help found for command: $Cmd"
    }
}
