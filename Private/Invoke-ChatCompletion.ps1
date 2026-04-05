<#
.SYNOPSIS
    Sends a request to an OpenAI-compatible Chat Completions API.
.DESCRIPTION
    This is a generic function that can be used with any provider that supports the 
    OpenAI Chat API format (e.g., OpenAI, Ollama, Groq, etc.).
.PARAMETER BaseUrl
    The base URL of the API (e.g., "https://api.openai.com/v1" or "http://localhost:11434/v1").
.PARAMETER Model
    The name of the model to use.
.PARAMETER Messages
    An array of hashtables representing the chat conversation. 
    Each hashtable should have 'role' and 'content' keys.
.PARAMETER ApiKey
    (Optional) The API key for authentication.
.PARAMETER Options
    (Optional) A hashtable of additional parameters like Temperature, TopP, and MaxTokens.
#>
function Invoke-ChatCompletion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $BaseUrl,

        [Parameter(Mandatory)]
        [string] $Model,

        [Parameter(Mandatory)]
        [System.Collections.Generic.List[hashtable]] $Messages,

        [securestring] $ApiKey,

        [hashtable] $Options = @{}
    )

    # Validate BaseUrl
    if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
        throw "BaseUrl is required."
    }

    # Construct the API endpoint
    $APIEndpoint = "$($BaseUrl.TrimEnd('/'))/chat/completions"

    # Construct Request Body
    $RequestBody = @{
        model    = $Model
        messages = $Messages
    }

    # Map options to OpenAI standard names
    if ($Options.ContainsKey("MaxTokens") -and $null -ne $Options.MaxTokens) { $RequestBody["max_tokens"] = $Options.MaxTokens }
    if ($Options.ContainsKey("Temperature") -and $null -ne $Options.Temperature) { $RequestBody["temperature"] = $Options.Temperature }
    if ($Options.ContainsKey("TopP") -and $null -ne $Options.TopP) { $RequestBody["top_p"] = $Options.TopP }
    if ($Options.ContainsKey("N") -and $null -ne $Options.N) { $RequestBody["n"] = $Options.N }

    # Convert request body to JSON
    $RequestJson = $RequestBody | ConvertTo-Json -Depth 10 -Compress

    # Prepare Headers
    $Headers = @{ "Content-Type" = "application/json" }
    if ($null -ne $ApiKey) {
        $PlainTextKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApiKey))
        $Headers["Authorization"] = "Bearer $PlainTextKey"
    }

    # Make the API Request
    $RequestParams = @{
        Uri     = $APIEndpoint
        Method  = "POST"
        Headers = $Headers
        Body    = $RequestJson
    }

    try {
        $Response = Invoke-RestMethod @RequestParams
        if ($Response -and $Response.choices -and $Response.choices.Count -gt 0) {
            $Content = $Response.choices[0].message.content.Trim()
            
            # Sanitize: Strip markdown code blocks if present
            # Matches ```[language] ... ``` or just ``` ... ```
            if ($Content -match "(?s)``````(?:[a-zA-Z0-9-]*\n)?(.*?)\n?``````") {
                $Content = $matches[1].Trim()
            }

            return $Content
        }
        else {
            Write-Error "Unexpected response format from API: $($Response | ConvertTo-Json -Depth 3)"
            return $null
        }
    }
    catch {
        Write-Error "Failed to communicate with API at $APIEndpoint : $($_.Exception.Message)"
        return $null
    }
}
