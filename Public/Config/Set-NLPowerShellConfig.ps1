<#
.SYNOPSIS
    Sets the configuration for NLPowerShell.
.DESCRIPTION
    Updates configuration settings, including provider, model, URL, and parameters.
    The API key is handled separately for security.
.EXAMPLE
    Set-NLPowerShellConfig -Provider "openai" -Model "gpt-4"
.EXAMPLE
    Set-NLPowerShellConfig -Temperature 0.7 -MaxTokens 1000
#>
function Set-NLPowerShellConfig(
    [string]$Provider,
    [string]$Model,
    [string]$URL,
    [securestring]$API_KEY,
    [string]$Organization,
    [double]$N,
    [int]$MaxTokens,
    [double]$Temperature,
    [double]$TopP
) {
    # Ensure Config object exists
    if (-not $Script:CONFIG) {
        $Script:CONFIG = [Config]::new()
    }

    # Set values only if parameters were explicitly provided
    if ($PSBoundParameters.ContainsKey("Provider")) {
        $Script:CONFIG.Provider = $Provider
        Write-Host "Updated Provider: $Provider" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("Model")) {
        $Script:CONFIG.Model = $Model
        Write-Host "Updated Model: $Model" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("URL")) {
        $Script:CONFIG.URL = $URL
        Write-Host "Updated API URL: $URL" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("API_KEY")) {
        $Script:CONFIG.API_KEY = $API_KEY
        Write-Host "API Key updated (securely stored)." -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("Organization")) {
        $Script:CONFIG.Organization = $Organization
        Write-Host "Updated Organization: $Organization" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("N")) {
        $Script:CONFIG.N = $N
        Write-Host "Updated N: $N" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("MaxTokens")) {
        $Script:CONFIG.MaxTokens = $MaxTokens
        Write-Host "Updated MaxTokens: $MaxTokens" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("Temperature")) {
        $Script:CONFIG.Temperature = $Temperature
        Write-Host "Updated Temperature: $Temperature" -ForegroundColor Cyan
    }

    if ($PSBoundParameters.ContainsKey("TopP")) {
        $Script:CONFIG.TopP = $TopP
        Write-Host "Updated TopP: $TopP" -ForegroundColor Cyan
    }

    Write-Host "Configuration updated successfully!" -ForegroundColor Green
}
