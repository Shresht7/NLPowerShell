<#
.SYNOPSIS
    Convert the given natural language prompt to PowerShell commands
#>
function Get-NLPowerShellCommand(
    # The comment to parse
    [Parameter(Mandatory)]
    [Alias("Line")]
    [string] $Comment
) {
    $Prompt = "Write powershell command to do the following: $Comment"
    
    $RequestParams = @{
        Uri            = "https://api.openai.com/v1/completions"
        Method         = "POST"
        Authentication = "Bearer"
        Token          = $Script:CONFIG.API_KEY
        Headers        = @{
            "Content-Type" = "application/json"
        }
        Body           = @{
            model  = "text-davinci-003"
            prompt = $Prompt
        } | ConvertTo-Json
    }

    $Response = Invoke-WebRequest @RequestParams

    # Best Fit
    $Result = ($Response.Content | ConvertFrom-Json).choices[0]
    return $Result.text
}
