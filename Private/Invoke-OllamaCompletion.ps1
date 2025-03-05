<#
.SYNOPSIS
    Make a request to Ollama API endpoint
.DESCRIPTION
    Makes a request to the local Ollama completions API endpoint with the given prompt
.PARAMETER Prompt
    The natural language prompt
.PARAMETER URL
    The URL of the Ollama API endpoint (defaults to config)
.PARAMETER Model
    The Ollama model to use (must be set by the user)
#>
function Invoke-OllamaCompletion {
    param(
        # The prompt to use for completion
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Prompt,

        # The URL of the API endpoint
        [string] $URL = ($Script:CONFIG.URL ?? "http://localhost:11434"),

        # The Ollama model to use
        [string] $Model = $Script:CONFIG.Model
    )

    # Validate that CONFIG is initialized
    if ($null -eq $Script:CONFIG) {
        Write-Error "Configuration not initialized. Run Initialize-NLPowerShell first."
        return $null
    }

    # Ensure a model is set
    if ([string]::IsNullOrWhiteSpace($Model)) {
        Write-Error "No model specified. Please set a model in the configuration."
        return $null
    }

    $APIEndpoint = "$URL/api/generate"

    # Request Parameters
    $RequestParams = @{
        Uri     = $APIEndpoint
        Method  = "POST"
        Headers = @{
            "Content-Type" = "application/json"
        }
        Body    = @{
            model  = $Model
            prompt = $Prompt
            stream = $False
        } | ConvertTo-Json
    }

    try {
        # Make the API Request
        $Response = Invoke-RestMethod @RequestParams
        return $Response.response.Trim()
    }
    catch {
        Write-Error "Failed to connect to Ollama API at $APIEndpoint. Ensure Ollama is running and the model '$Model' is installed."
        return $null
    }
}
