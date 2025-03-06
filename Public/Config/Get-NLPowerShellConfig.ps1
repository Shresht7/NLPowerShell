<#
.SYNOPSIS
    Retrieves the current configuration for NLPowerShell.
.DESCRIPTION
    Displays the current settings for NLPowerShell, excluding the API key for security reasons.
#>
function Get-NLPowerShellConfig() {
    # Ensure configuration is initialized
    if (-not $Script:CONFIG) {
        Write-Warning "Configuration not initialized. Please set Initialize-NLPowerShell first."
        return
    }
    
    $configCopy = $Script:CONFIG | Select-Object -Property *
    if ($configCopy.PSObject.Properties["API_KEY"]) { $configCopy.API_KEY = "******" }

    # Output the filtered configuration
    Write-Output $configCopy
}
