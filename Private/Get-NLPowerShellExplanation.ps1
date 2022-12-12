<#
.SYNOPSIS
    Explains the current line using OpenAI
#>
function Get-NLPowerShellExplanation(
    # The line to explain
    [Parameter(Mandatory)]
    [string] $Line
) {
    $Prompt = "Explain, using imperative speech, the following PowerShell command in a single line:`n$Line"

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

    $Response = Invoke-WebRequest @RequestParams

    # Best Fit
    $Result = ($Response.Content | ConvertFrom-Json).choices[0]
    return $Result.text.Trim()
}
