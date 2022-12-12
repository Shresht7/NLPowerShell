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
    # Request Parameters
    $RequestParams = @{
        Uri            = "https://api.openai.com/v1/completions"
        Method         = "POST"
        Authentication = "Bearer"
        Token          = $Script:CONFIG.API_KEY
        Headers        = @{
            "Content-Type" = "application/json"
        }
        Body           = @{
            model       = $Script:CONFIG.MODEL_NAME
            prompt      = $Prompt
            max_tokens  = $Script:CONFIG.MAX_TOKENS
            temperature = $Script:CONFIG.TEMPERATURE
            n           = $Script:CONFIG.N
            stop        = @("#")
        } | ConvertTo-Json
    }

    # Make the API Request and return the response
    $Response = Invoke-RestMethod @RequestParams
    return $Response
}
