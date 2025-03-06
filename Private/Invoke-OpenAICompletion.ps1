<#
.SYNOPSIS
    Make a request to OpenAI Completions endpoint
.DESCRIPTION
    Sends a prompt to OpenAI's API and returns the completion response
.PARAMETER Prompt
    The natural language prompt to convert to a PowerShell command
#>
function Invoke-OpenAICompletion(
    # The prompt to use for completion
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Prompt
) {
    # Validate API Key
    $APIKey = ConvertFrom-SecureString -SecureString $Script:CONFIG.API_KEY -AsPlainText
    if ([string]::IsNullOrWhiteSpace($APIKey)) {
        Write-Error "OpenAI API Key is missing. Please set API_KEY in the configuration."
        return $null
    }

    # Validate Model
    if ([string]::IsNullOrWhiteSpace($Script:CONFIG.Model)) {
        Write-Error "No model specified. Please set a model in your configuration before making requests."
        return $null
    }

    $APIEndpoint = "https://api.openai.com/v1/completions"

    # Construct Request Body
    $RequestBody = @{
        model  = $Script:CONFIG.Model
        prompt = $Prompt
        stop   = @("#")  # Stop generation at a comment
    }

    # Add optional parameters if set in the configuration
    if ($null -ne $Script:CONFIG.MaxTokens) {
        $RequestBody["max_tokens"] = $Script:CONFIG.MaxTokens
    }

    if ($null -ne $Script:CONFIG.Temperature) {
        $RequestBody["temperature"] = $Script:CONFIG.Temperature
    }

    if ($null -ne $Script:CONFIG.N) {
        $RequestBody["n"] = $Script:CONFIG.N
    }

    # Convert request body to JSON
    $RequestJson = $RequestBody | ConvertTo-Json -Depth 3 -Compress

    # Request Parameters
    $RequestParams = @{
        Uri     = $APIEndpoint
        Method  = "POST"
        Headers = @{
            "Content-Type"  = "application/json"
            "Authorization" = "Bearer $APIKey"
        }
        Body    = $RequestJson
    }

    # Make API request
    try {
        $Response = Invoke-RestMethod @RequestParams
        if ($Response -and $Response.PSObject.Properties["choices"] -and $Response.choices.Count -gt 0) {
            return $Response.choices[0].text.Trim()
        }
        else {
            Write-Error "Unexpected response from OpenAI: $($Response | ConvertTo-Json -Depth 3)"
            return $null
        }
    }
    catch {
        Write-Error "Failed to communicate with OpenAI API: $($_.Exception.Message)"
        return $null
    }
}
