<#
.SYNOPSIS
    Initializes the NLPowerShell configuration
.DESCRIPTION
    Sets up the configuration for either a Local inference engine (Ollama, llama.cpp) or OpenAI.
    If no parameters are provided, it attempts to load the configuration from the default location.
    If parameters are provided, they override the values from the default configuration.
.EXAMPLE
    Initialize-NLPowerShell
.EXAMPLE
    Initialize-NLPowerShell -Model "llama3.1:70b"
.EXAMPLE
    Initialize-NLPowerShell -Local -Model "llama3.2"
#>
function Initialize-NLPowerShell(
    [Parameter(ParameterSetName = "Local")]
    [Alias("Ollama")]
    [switch] $Local,

    [Parameter(ParameterSetName = "OpenAI")]
    [switch] $OpenAI,

    [Parameter(Mandatory, ParameterSetName = "Config")]
    [string] $Path,

    # The model to use
    [string] $Model,

    # The URL address of the running local instance (default: http://localhost:11434)
    [Parameter(ParameterSetName = "Local")]
    [string] $URL,

    # The OpenAI `API_KEY` for authentication.
    [Parameter(ParameterSetName = "OpenAI")]
    [securestring] $API_KEY,

    # The maximum number of tokens to generate in the completion
    [int] $MaxTokens,
    
    # The sampling temperature to use.
    [double] $Temperature,
    
    [double] $TopP,

    # Whether to enable AI self-correction retry
    [bool] $EnableRetry,

    # Maximum number of retry attempts for self-correction
    [int] $MaxRetries,

    # The keybinding to use to trigger NLPowerShell
    [string] $KeyBind
) {    
    # Start by loading the default config if available
    if ($PSCmdlet.ParameterSetName -ne "Config") {
        $DefaultPath = [Config]::GetDefaultPath()
        if (Test-Path $DefaultPath) {
            # This sets $Script:CONFIG
            $null = Import-NLPowerShellConfig -Path $DefaultPath
        }
    }

    # Handle specific file path initialization
    if ($PSCmdlet.ParameterSetName -eq "Config") {
        $null = Import-NLPowerShellConfig -Path $Path
    }

    # Ensure we have a Config object to work with
    if ($null -eq $Script:CONFIG) {
        $Script:CONFIG = [Config]::new()
    }

    # Handle Overrides / Provider Switching
    if ($Local) {
        if (-not ($Script:CONFIG.ActiveProvider -is [LocalProvider])) {
            $Script:CONFIG.ActiveProvider = [LocalProvider]::new()
        }
    }
    elseif ($OpenAI) {
        if (-not ($Script:CONFIG.ActiveProvider -is [OpenAIProvider])) {
            $Script:CONFIG.ActiveProvider = [OpenAIProvider]::new()
        }
    }

    # Apply Parameter Overrides to ActiveProvider
    if ($Script:CONFIG.ActiveProvider) {
        if ($PSBoundParameters.ContainsKey("Model")) { $Script:CONFIG.ActiveProvider.Model = $Model }
        if ($PSBoundParameters.ContainsKey("MaxTokens")) { $Script:CONFIG.ActiveProvider.MaxTokens = $MaxTokens }
        if ($PSBoundParameters.ContainsKey("Temperature")) { $Script:CONFIG.ActiveProvider.Temperature = $Temperature }
        if ($PSBoundParameters.ContainsKey("TopP")) { $Script:CONFIG.ActiveProvider.TopP = $TopP }
        if ($PSBoundParameters.ContainsKey("EnableRetry")) { $Script:CONFIG.ActiveProvider.EnableRetry = $EnableRetry }
        if ($PSBoundParameters.ContainsKey("MaxRetries")) { $Script:CONFIG.ActiveProvider.MaxRetries = $MaxRetries }
        
        # Local URL
        if ($PSBoundParameters.ContainsKey("URL") -and ($Script:CONFIG.ActiveProvider -is [LocalProvider])) {
            $Script:CONFIG.ActiveProvider.BaseUrl = "$($URL.TrimEnd('/'))/v1"
        }

        # OpenAI API Key
        if ($PSBoundParameters.ContainsKey("API_KEY") -and ($Script:CONFIG.ActiveProvider -is [OpenAICompatibleProvider])) {
            $Script:CONFIG.ActiveProvider.ApiKey = $API_KEY
        }
    }

    # Common Overrides
    if ($PSBoundParameters.ContainsKey("KeyBind")) { $Script:CONFIG.KeyBind = $KeyBind }

    # Final Check & Registration
    if ($Script:CONFIG.ActiveProvider) {
        Register-PSReadlineKeyHandler -KeyBind $Script:CONFIG.KeyBind
    }
    else {
        if ($PSCmdlet.ParameterSetName -ne "__AllParameterSets") {
            Write-Warning "Configuration initialized but no active provider is set. Please run Initialize-NLPowerShell with -Local or -OpenAI."
        }
    }
}
