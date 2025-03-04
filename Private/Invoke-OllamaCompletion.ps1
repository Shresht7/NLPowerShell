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
    [string] $Prompt
) {
    # Request Parameters
    $RequestParams = @{
        Uri     = "http://localhost:11434/api/generate"
        Method  = "POST"
        Headers = @{
            "Content-Type" = "application/json"
        }
        Body    = @{
            model  = "llama3.2"
            prompt = $Prompt
            stream = $True
        } | ConvertTo-Json
    }

    # Make the API Request and return the response
    $Response = Invoke-RestMethod @RequestParams
    return $Response.response.Trim()
}
