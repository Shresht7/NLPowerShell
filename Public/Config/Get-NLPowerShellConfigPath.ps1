<#
.SYNOPSIS
    Returns the path to the NLPowerShell configuration file.
.DESCRIPTION
    Retrieves the platform-specific default path for the config.json file.
.EXAMPLE
    Get-NLPowerShellConfigPath
#>
function Get-NLPowerShellConfigPath {
    return [Config]::GetDefaultPath()
}
