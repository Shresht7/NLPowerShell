<#
.SYNOPSIS
    Sets the configuration for NLPowerShell.
.DESCRIPTION
    Updates configuration settings, including provider type, model, and generation parameters.
.EXAMPLE
    Set-NLPowerShellConfig -Model "gpt-4o"
.EXAMPLE
    Set-NLPowerShellConfig -Temperature 0.7 -MaxTokens 256 -EnableRetry $true -MaxRetries 3
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
    [bool]$EnableRetry,
    [int]$MaxRetries,
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
    if ($PSBoundParameters.ContainsKey("Model")) { $Script:CONFIG.ActiveProvider.Model = $Model }
    if ($PSBoundParameters.ContainsKey("MaxTokens")) { $Script:CONFIG.ActiveProvider.MaxTokens = $MaxTokens }
    if ($PSBoundParameters.ContainsKey("Temperature")) { $Script:CONFIG.ActiveProvider.Temperature = $Temperature }
    if ($PSBoundParameters.ContainsKey("TopP")) { $Script:CONFIG.ActiveProvider.TopP = $TopP }
    if ($PSBoundParameters.ContainsKey("EnableRetry")) { $Script:CONFIG.ActiveProvider.EnableRetry = $EnableRetry }
    if ($PSBoundParameters.ContainsKey("MaxRetries")) { $Script:CONFIG.ActiveProvider.MaxRetries = $MaxRetries }

    if ($PSBoundParameters.ContainsKey("ApiKey")) {
        if ($Script:CONFIG.ActiveProvider.PSObject.Properties["ApiKey"]) {
            $Script:CONFIG.ActiveProvider.ApiKey = $ApiKey
            Write-Host "API Key updated." -ForegroundColor Cyan
        }
    }

    if ($PSBoundParameters.ContainsKey("URL")) {
        if ($Script:CONFIG.ActiveProvider.PSObject.Properties["BaseUrl"]) {
            $Script:CONFIG.ActiveProvider.BaseUrl = if ($Script:CONFIG.ActiveProvider -is [LocalProvider]) { "$($URL.TrimEnd('/'))/v1" } else { $URL }
            Write-Host "Updated API URL: $URL" -ForegroundColor Cyan
        }
    }

    # Update KeyBind
    if ($PSBoundParameters.ContainsKey("KeyBind")) {
        $Script:CONFIG.KeyBind = $KeyBind
        Register-PSReadlineKeyHandler -KeyBind $KeyBind
        Write-Host "Updated KeyBind: $KeyBind" -ForegroundColor Cyan
    }

    Write-Host "Configuration updated successfully!" -ForegroundColor Green
}
