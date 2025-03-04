<#
.SYNOPSIS
    Make a request to Ollama API endpoint
.DESCRIPTION
    Makes a request to the local Ollama completions API endpoint with the given prompt
.PARAMETER Comment
    The natural language prompt
#>
function Invoke-OllamaCompletion(
    # The prompt to use for completion
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Prompt,

    # The URL of the API endpoint
    [string] $URL = $Script:CONFIG.URL,

    # The ollama model to use
    [string] $Model = $Script:CONFIG.Model
) {
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

    # Make the API Request and return the response
    $Response = Invoke-RestMethod @RequestParams
    if ($null -ne $Response) {
        $Response = $Response.response.Trim()
    }

    return $Response
}
