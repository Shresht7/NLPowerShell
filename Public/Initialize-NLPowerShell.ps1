<#
.SYNOPSIS
    Initializes the NLPowerShell configuration
.DESCRIPTION
    Sets up the configuration for either Ollama or OpenAI
.EXAMPLE
    Get-NLPowerShellConfig -Path "C:\path\to\config.json"
#>
function Initialize-NLPowerShell(
    [Parameter(Mandatory, ParameterSetName = "Ollama")]
    [switch] $Ollama,
    [Parameter(Mandatory, ParameterSetName = "OpenAI")]
    [switch] $OpenAI,

    [Parameter(Mandatory, ParameterSetName = "Config")]
    [string] $Path,

    # The model to use
    [Parameter(Mandatory)]
    [string] $Model,

    # The URL address of the running Ollama instance
    [Parameter(ParameterSetName = "Ollama")]
    [string] $URL = "http://localhost:11434",

    # The OpenAI `API_KEY` for authentication.
    [Parameter(Mandatory, ParameterSetName = "OpenAI")]
    [securestring] $API_KEY,

    # The maximum number of tokens to generate in the completion
    [int] $MaxTokens = 64,
    
    # The sampling temperature to use.
    [double] $Temperature = 0.1,
    
    [double] $TopP = 1,

    # The keybinding to use to trigger NLPowerShell
    [string] $KeyBind = "Ctrl+Shift+Insert"
) {    
    # Initialize the Config Object
    if ($PSCmdlet.ParameterSetName -eq "Config") {
        Import-NLPowerShellConfig -Path $Path
    }
    else {
        $Script:CONFIG = [Config]::new()
        $Script:CONFIG.KeyBind = $KeyBind

        # Ollama Specific Configuration
        if ($Ollama) {
            $Script:CONFIG.ActiveProvider = [OllamaProvider]::new($URL, $Model)
        }
        
        # OpenAI Specific Configuration
        if ($OpenAI) {
            $Script:CONFIG.ActiveProvider = [OpenAIProvider]::new($Model, $API_KEY)
        }
    
        # Common Configuration
        if ($Script:CONFIG.ActiveProvider) {
            $Script:CONFIG.ActiveProvider.MaxTokens = $MaxTokens
            $Script:CONFIG.ActiveProvider.Temperature = $Temperature
            $Script:CONFIG.ActiveProvider.TopP = $TopP
        }
    }

    # Register the key event handler
    Register-PSReadLineKeyHandler -KeyBind $Script:CONFIG.KeyBind
}
