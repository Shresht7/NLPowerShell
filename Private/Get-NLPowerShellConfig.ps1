<#
.SYNOPSIS
    Retrieves the configuration
#>
function Get-NLPowerShellConfig(
    # The path to the configuration file
    [Parameter(Mandatory)]
    [string] $Path
) {    
    # Check to see if the config file actually exists
    if (-Not (Test-Path -Path $Path)) { return $null }

    # Retrieve and parse the JSON configuration
    try {
        return Get-Content -Path $Path | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to parse config.json: $_"
        return $null
    }
}
