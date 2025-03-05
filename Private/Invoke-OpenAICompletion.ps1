<#
.SYNOPSIS
    Make a request to OpenAI Completions endpoint
.DESCRIPTION
    Makes a request to the OpenAI Completions endpoint with the given prompt
.PARAMETER Comment
    The natural language prompt to convert to a PowerShell command.
    This parameter is mandatory and should not be empty or null.
#>
function Invoke-OpenAICompletion(
    # The prompt to use for completion
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Prompt
) {
    # Validate API key
    if ($null -eq $Script:CONFIG.API_KEY -or [string]::IsNullOrWhiteSpace((ConvertFrom-SecureString -SecureString $Script:CONFIG.API_KEY))) {
        Write-Error "OpenAI API Key is missing. Please set API_KEY in the configuration."
        return $null
    }

    # Validate Model
    if ([string]::IsNullOrWhiteSpace($Script:CONFIG.Model)) {
        Write-Error "No model specified. Please set a model in your configuration before making requests."
        return $null
    }

    # OpenAI API Endpoint
    $APIEndpoint = "https://api.openai.com/v1/completions"

    # Construct Request Body
    $RequestBody = @{
        model   = $Script:CONFIG.Model
        prompt  = $Prompt
        stop    = @("#")  # Stop generation at a comment to prevent excess output
        options = @{}
    }

    # Add optional parameters if they exist in the config
    if ($Script:CONFIG.PSObject.Properties["MaxTokens"] -and $null -ne $Script:CONFIG.MaxTokens) {
        $RequestBody["max_tokens"] = $Script:CONFIG.MaxTokens
    }

    if ($Script:CONFIG.PSObject.Properties["Temperature"] -and $null -ne $Script:CONFIG.Temperature) {
        $RequestBody["temperature"] = $Script:CONFIG.Temperature
    }

    if ($Script:CONFIG.PSObject.Properties["N"] -and $null -ne $Script:CONFIG.N) {
        $RequestBody["n"] = $Script:CONFIG.N
    }

    # Convert request body to JSON
    $RequestJson = $RequestBody | ConvertTo-Json -Depth 2

    # Request Parameters
    $RequestParams = @{
        Uri     = $APIEndpoint
        Method  = "POST"
        Headers = @{
            "Content-Type"  = "application/json"
            "Authorization" = "Bearer $(ConvertFrom-SecureString -SecureString $Script:CONFIG.API_KEY -AsPlainText)"
        }
        Body    = $RequestJson
    }

    # Make API request
    try {
        $Response = Invoke-RestMethod @RequestParams
        if ($null -ne $Response -and $Response.PSObject.Properties["choices"] -and $Response.choices.Count -gt 0) {
            return $Response.choices[0].text.Trim()
        }
    }
    catch {
        Write-Error "Failed to communicate with OpenAI API: $_"
        return $null
    }
}
