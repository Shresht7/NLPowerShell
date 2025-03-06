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

    # Set values only if parameters are provided
    if ($Provider) { $Script:CONFIG.Provider = $Provider }
    if ($Model) { $Script:CONFIG.Model = $Model }
    if ($URL) { $Script:CONFIG.URL = $URL }
    if ($API_KEY) { $Script:CONFIG.API_KEY = $API_KEY }
    if ($Organization) { $Script:CONFIG.Organization = $Organization }
    if ($N) { $Script:CONFIG.N = $N }
    if ($MaxTokens) { $Script:CONFIG.MaxTokens = $MaxTokens }
    if ($Temperature) { $Script:CONFIG.Temperature = $Temperature }
    if ($TopP) { $Script:CONFIG.TopP = $TopP }
    
    Write-Host "Configuration updated successfully." -ForegroundColor Green
}
