<#
.SYNOPSIS
    Make a request to the Ollama API endpoint
.DESCRIPTION
    Makes a request to the local Ollama completions API endpoint with the given prompt
.PARAMETER Prompt
    The natural language prompt to send to Ollama
.PARAMETER URL
    The base URL of the Ollama API endpoint
.PARAMETER Model
    The Ollama model to use for completion
#>
function Invoke-OllamaCompletion(
    # The prompt to use for completion
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Prompt,

    # The URL of the API endpoint
    [string] $URL = $Script:CONFIG.URL,

    # The Ollama model to use
    [string] $Model = $Script:CONFIG.Model
) {
    # Validate that a model is set
    if ([string]::IsNullOrWhiteSpace($Model)) {
        Write-Error "No model specified. Please set a model in your configuration before making requests."
        return $null
    }

    $APIEndpoint = "$URL/api/generate"

    # Construct the request body with options
    $RequestBody = @{
        model   = $Model
        prompt  = $Prompt
        stream  = $false
        options = @{}
    }

    # Add optional parameters if they are set in the configuration
    if ($Script:CONFIG.PSObject.Properties["Temperature"] -and $null -ne $Script:CONFIG.Temperature) {
        $RequestBody.options["temperature"] = $Script:CONFIG.Temperature
    }

    if ($Script:CONFIG.PSObject.Properties["TopP"] -and $null -ne $Script:CONFIG.TopP) {
        $RequestBody.options["top_p"] = $Script:CONFIG.TopP
    }

    if ($Script:CONFIG.PSObject.Properties["N"] -and $null -ne $Script:CONFIG.N) {
        $RequestBody.options["num_predict"] = $Script:CONFIG.N
    }

    # Convert to JSON, ensuring correct depth for nested objects
    $RequestJson = $RequestBody | ConvertTo-Json -Depth 2

    # Request Parameters
    $RequestParams = @{
        Uri     = $APIEndpoint
        Method  = "POST"
        Headers = @{ "Content-Type" = "application/json" }
        Body    = $RequestJson
    }

    # Make the API Request and return the response
    try {
        $Response = Invoke-RestMethod @RequestParams
        if ($null -ne $Response -and $Response.PSObject.Properties["response"]) {
            return $Response.response.Trim()
        }
    }
    catch {
        Write-Error "Failed to make request to Ollama API: $_"
        return $null
    }
}
