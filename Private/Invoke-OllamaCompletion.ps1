<#
.SYNOPSIS
    Make a request to the Ollama API endpoint
.DESCRIPTION
    Sends a prompt to the Ollama API and returns the completion response
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

    # Validate that a URL is set
    if ([string]::IsNullOrWhiteSpace($URL)) {
        Write-Error "No API URL specified. Please set a valid Ollama API URL in your configuration."
        return $null
    }

    # Construct API endpoint
    $APIEndpoint = "$URL/api/generate"

    # Construct the request body
    $RequestBody = @{
        model   = $Model
        prompt  = $Prompt
        stream  = $false
        options = @{}
    }

    # Add optional parameters if set in the configuration
    if ($Script:CONFIG.PSObject.Properties["Temperature"] -and $null -ne $Script:CONFIG.Temperature) {
        $RequestBody.options["temperature"] = $Script:CONFIG.Temperature
    }

    if ($Script:CONFIG.PSObject.Properties["TopP"] -and $null -ne $Script:CONFIG.TopP) {
        $RequestBody.options["top_p"] = $Script:CONFIG.TopP
    }

    if ($Script:CONFIG.PSObject.Properties["MaxTokens"] -and $null -ne $Script:CONFIG.MaxTokens) {
        $RequestBody.options["num_predict"] = $Script:CONFIG.MaxTokens
    }

    # Convert request body to JSON
    $RequestJson = $RequestBody | ConvertTo-Json -Depth 3 -Compress

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
        else {
            Write-Error "Ollama API responded with an unexpected format: $($Response | ConvertTo-Json -Depth 3)"
            return $null
        }
    }
    catch {
        Write-Error "Failed to make request to Ollama API: $($_.Exception.Message)"
        return $null
    }
}
