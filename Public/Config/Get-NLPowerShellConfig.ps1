<#
.SYNOPSIS
    Retrieves the current configuration for NLPowerShell.
.DESCRIPTION
    Displays the current settings for NLPowerShell, including provider-specific details.
#>
function Get-NLPowerShellConfig() {
    # Ensure configuration is initialized
    if (-not $Script:CONFIG) {
        Write-Warning "Configuration not initialized. Please run Initialize-NLPowerShell first."
        return
    }
    
    # Create a flat representation for display
    $DisplayConfig = [ordered]@{
        KeyBind      = $Script:CONFIG.KeyBind
        ProviderType = $Script:CONFIG.ActiveProvider.GetType().Name
    }

    # Add provider properties
    if ($Script:CONFIG.ActiveProvider) {
        foreach ($prop in $Script:CONFIG.ActiveProvider.PSObject.Properties) {
            if ($prop.Name -eq 'ApiKey' -and $prop.Value) {
                $DisplayConfig["ApiKey"] = "******"
            }
            else {
                $DisplayConfig[$prop.Name] = $prop.Value
            }
        }
    }

    return [PSCustomObject]$DisplayConfig
}
