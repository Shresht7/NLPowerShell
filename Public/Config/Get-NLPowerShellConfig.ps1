
<#
.SYNOPSIS
    Retrieves the current configuration for NLPowerShell.
.DESCRIPTION
    Displays the current settings for NLPowerShell, excluding the API key for security reasons.
#>
function Get-NLPowerShellConfig() {
    if (-not $Script:CONFIG) {
        Write-Warning -Message "Configuration not initialized. Please set up NLPowerShell first."
        return
    }
    # Create a copy of the configuration but mask the API key for security
    $configCopy = $Script:CONFIG | Select-Object -Property * -ExcludeProperty API_KEY
    Write-Output $configCopy
}
