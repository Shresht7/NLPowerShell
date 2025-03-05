<#
.SYNOPSIS
    Initializes the NLPowerShell configuration
.DESCRIPTION
    Sets up the configuration for either Ollama or OpenAI
.EXAMPLE
    Get-NLPowerShellConfig -Path "C:\path\to\config.json"
#>
function Initialize-NLPowerShell {
    param(
        [Parameter(Mandatory, ParameterSetName = "Ollama")]
        [switch] $Ollama,
        [Parameter(Mandatory, ParameterSetName = "OpenAI")]
        [switch] $OpenAI,

        # The model to use
        [Parameter(Mandatory)]
        [string] $Model,

        # The URL address of the running Ollama instance
        [Parameter(ParameterSetName = "Ollama")]
        [string] $URL = "http://localhost:11434",

        # The OpenAI `API_KEY` for authentication. This is required to make api requests to OpenAI.
        [Parameter(Mandatory, ParameterSetName = "OpenAI")]
        [securestring] $API_KEY,

        # Users can belong to multiple organizations, you can specify which organization is used for an API request.
        # Usage from these API requests will count against the specified organization's subscription quota.
        [Parameter(ParameterSetName = "OpenAI")]
        [string] $Organization,

        # The maximum number of tokens to generate in the completion
        [Parameter(ParameterSetName = "OpenAI")]
        [int] $MaxTokens = 64,

        # The sampling temperature to use. Higher values mean the model will take more risks.
        # Higher values are for creative applications, and 0 for well-defined answers.
        [Parameter(ParameterSetName = "OpenAI")]
        [double] $Temperature = 0.1,

        [Parameter(ParameterSetName = "OpenAI")]
        [double] $TopP = 1,

        # How many completions to generate for each prompt
        [Parameter(ParameterSetName = "OpenAI")]
        [int] $N = 1
    )    

    # Initialize the Config Object
    $Script:CONFIG = [Config]::new()

    # Ollama Specific Configuration
    if ($Ollama) {
        $Script:CONFIG.Provider = "ollama"
        $Script:CONFIG.Model = $Model
        $Script:CONFIG.URL = $URL
    }
    
    # OpenAI Specific Configuration
    if ($OpenAI) {
        $Script:CONFIG.Provider = "openai"
        $Script:CONFIG.Model = $Model
        $Script:CONFIG.API_KEY = $API_KEY ?? (Read-Host -AsSecureString -Prompt "OpenAI API Key")
        $Script:CONFIG.Organization = $Organization
        $Script:CONFIG.MaxTokens = $MaxTokens
        $Script:CONFIG.Temperature = $Temperature
        $Script:CONFIG.TopP = $TopP
        $Script:CONFIG.N = $N
    }

    # Register the key event handler
    Register-PSSReadlineKeyHandler
}
