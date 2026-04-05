<#
.SYNOPSIS
    Validates all commands, subcommands, and parameters in a generated PowerShell script.
.DESCRIPTION
    Uses the AST parser to inspect each command call. 
    Returns a list of structured error messages for the AI to fix.
.PARAMETER Script
    The generated PowerShell command string to validate.
.OUTPUTS
    An array of descriptive error strings for each validation failure.
#>
function Test-GeneratedCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Script
    )

    # If the script is empty or whitespace, return an empty array (no commands to validate)
    if ([string]::IsNullOrWhiteSpace($Script)) { return @() }

    # List of validation failure messages to return
    $Failures = @()

    # Parse the generated script
    $Errors = $null
    $Tokens = $null
    $AST = [System.Management.Automation.Language.Parser]::ParseInput($Script, [ref]$Tokens, [ref]$Errors)

    if ($Errors) {
        foreach ($ParseError in $Errors) {
            $ExtentText = $ParseError.Extent.Text
            if ([string]::IsNullOrWhiteSpace($ExtentText)) {
                $Failures += "Syntax error: $($ParseError.Message)"
            }
            else {
                $Failures += "Syntax error: $($ParseError.Message) Near: $ExtentText"
            }
        }

        return $Failures | Select-Object -Unique
    }

    # Find all CommandAst nodes in the AST (these represent command invocations. e.g. Get-ChildItem, git etc.)
    $CommandNodes = $AST.FindAll({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $true)

    # Iterate over each command node and validate it
    foreach ($Node in $CommandNodes) {
        $CmdName = $Node.GetCommandName()
        if (-not $CmdName) { continue } # If we can't determine the command name, skip validation for this node

        # Resolve command info
        $CommandInfo = Get-Command $CmdName -ErrorAction SilentlyContinue
        if ($null -eq $CommandInfo) {
            $Failures += "Command '$CmdName' was not found on this system."
            continue
        }

        # Handle Native PowerShell (Cmdlet, Function, Alias)
        if ($CommandInfo.CommandType -in @('Cmdlet', 'Function', 'Filter', 'Alias')) {
            # Extract parameters used in the AST
            $UsedParams = $Node.CommandElements | Where-Object { $_ -is [System.Management.Automation.Language.CommandParameterAst] }
            
            $AvailableParams = $CommandInfo.Parameters.Keys
            foreach ($P in $UsedParams) {
                $ParamName = $P.ParameterName
                # Check for exact match or unambiguous prefix match (Standard PowerShell behavior)
                $M = $AvailableParams | Where-Object { $_.StartsWith($ParamName, [System.StringComparison]::OrdinalIgnoreCase) }
                if ($M.Count -eq 0) {
                    $Failures += "Parameter '-$ParamName' is invalid for command '$CmdName'."
                }
                elseif ($M.Count -gt 1 -and -not ($M -contains $ParamName)) {
                    $Failures += "Parameter '-$ParamName' is ambiguous for command '$CmdName'. Matches: $($M -join ', ')."
                }
            }
        }

        # Handle External Applications (git, docker, etc.)
        elseif ($CommandInfo.CommandType -eq 'Application') {
            # Check for potential Subcommand (first element after command name that is a string and not a parameter)
            $Subcommand = $null
            if ($Node.CommandElements.Count -gt 1) {
                $FirstArg = $Node.CommandElements[1]
                if ($FirstArg -is [System.Management.Automation.Language.StringConstantExpressionAst] -and -not $FirstArg.Value.StartsWith("-")) {
                    $Subcommand = $FirstArg.Value
                }
            }

            # Check for flags (elements starting with - or --)
            $Flags = $Node.CommandElements | Where-Object { 
                ($_ -is [System.Management.Automation.Language.CommandParameterAst]) -or 
                ($_ -is [System.Management.Automation.Language.StringConstantExpressionAst] -and $_.Value.StartsWith("-"))
            } | ForEach-Object { if ($_ -is [System.Management.Automation.Language.CommandParameterAst]) { "-$($_.Extent.Text)" } else { $_.Value } }

            # Fetch help text for verification (if subcommand exists, fetch its specific help if possible)
            if ($Subcommand -or $Flags.Count -gt 0) {
                try {
                    $HelpText = if ($Subcommand) {
                        # Try: git commit --help
                        & $CmdName $Subcommand --help 2>&1 | Out-String
                    }
                    else {
                        # Try: git --help
                        & $CmdName --help 2>&1 | Out-String
                    }

                    if (-not [string]::IsNullOrWhiteSpace($HelpText)) {
                        # Validate Subcommand if it was identified
                        if ($Subcommand -and $HelpText -notmatch "\b$Subcommand\b") {
                            # Note: This is a heuristic. Some tools don't list subcommands in help.
                            # We check if it looks like a valid subcommand via exit code
                            & $CmdName $Subcommand --help > $null 2>&1
                            if ($LASTEXITCODE -ne 0) {
                                $Failures += "Subcommand '$Subcommand' might be invalid for '$CmdName'."
                            }
                        }

                        # Validate Flags via simple "grep" in help text
                        foreach ($F in $Flags) {
                            # Check if the flag (or its base if it's -f) exists in the help
                            # Using word boundary to avoid partial matches
                            $FlagPattern = [regex]::Escape($F)
                            if ($HelpText -notmatch $FlagPattern) {
                                $Failures += "Flag '$F' was not found in the help documentation for '$CmdName'."
                            }
                        }
                    }
                }
                catch {}
            }
        }
    }

    return $Failures | Select-Object -Unique
}
