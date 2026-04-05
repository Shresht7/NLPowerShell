<#
.SYNOPSIS
    Sets the configuration for NLPowerShell.
.DESCRIPTION
    Updates configuration settings, including provider type, model, and generation parameters.
.EXAMPLE
    Set-NLPowerShellConfig -Model "gpt-4o"
.EXAMPLE
    Set-NLPowerShellConfig -Temperature 0.7 -MaxTokens 128
#>
function Set-NLPowerShellConfig(
    [ValidateSet("OpenAI", "Local")]
    [string]$Provider,
    [string]$Model,
    [string]$URL,
    [securestring]$ApiKey,
    [int]$MaxTokens,
    [double]$Temperature,
    [double]$TopP,
    [string]$KeyBind
) {
    # Ensure Config object exists
    if (-not $Script:CONFIG) {
        $Script:CONFIG = [Config]::new()
    }

    # Switch Provider if requested
    if ($PSBoundParameters.ContainsKey("Provider")) {
        if ($Provider -eq "OpenAI") {
            $Script:CONFIG.ActiveProvider = [OpenAIProvider]::new()
        }
        elseif ($Provider -eq "Local") {
            $Script:CONFIG.ActiveProvider = [LocalProvider]::new()
        }
        Write-Host "Switched Provider to: $Provider" -ForegroundColor Cyan
    }

    # Ensure ActiveProvider exists for following updates
    if (-not $Script:CONFIG.ActiveProvider) {
        Write-Error "No active provider. Please run Initialize-NLPowerShell or specify -Provider."
        return
    }

    # Update Provider Properties
    if ($PSBoundParameters.ContainsKey("Model")) {
        $Script:CONFIG.ActiveProvider.Model = $Model
        Write-Host "Updated Model: $Model" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("ApiKey")) {
        # Check if the property exists (some providers might not use it)
        if ($Script:CONFIG.ActiveProvider.PSObject.Properties["ApiKey"]) {
            $Script:CONFIG.ActiveProvider.ApiKey = $ApiKey
            Write-Host "API Key updated." -ForegroundColor Cyan
        }
    }

    if ($PSBoundParameters.ContainsKey("URL")) {
        if ($Script:CONFIG.ActiveProvider.PSObject.Properties["BaseUrl"]) {
            # Map URL to BaseUrl for OpenAI-compatible providers
            $Script:CONFIG.ActiveProvider.BaseUrl = if ($Script:CONFIG.ActiveProvider -is [LocalProvider]) { "$($URL.TrimEnd('/'))/v1" } else { $URL }
            Write-Host "Updated API URL: $URL" -ForegroundColor Cyan
        }
    }

    # Update Common Parameters
    if ($PSBoundParameters.ContainsKey("MaxTokens")) {
        $Script:CONFIG.ActiveProvider.MaxTokens = $MaxTokens
        Write-Host "Updated MaxTokens: $MaxTokens" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("Temperature")) {
        $Script:CONFIG.ActiveProvider.Temperature = $Temperature
        Write-Host "Updated Temperature: $Temperature" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("TopP")) {
        $Script:CONFIG.ActiveProvider.TopP = $TopP
        Write-Host "Updated TopP: $TopP" -ForegroundColor Cyan
    }

    # Update KeyBind
    if ($PSBoundParameters.ContainsKey("KeyBind")) {
        $Script:CONFIG.KeyBind = $KeyBind
        Register-PSReadlineKeyHandler -KeyBind $KeyBind
        Write-Host "Updated KeyBind: $KeyBind" -ForegroundColor Cyan
    }

    Write-Host "Configuration updated successfully!" -ForegroundColor Green
}
