<#
.SYNOPSIS
    Convert the given natural language prompt to PowerShell commands
#>
function Get-NLPowerShellCommand([string] $Line) {
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
            prompt = "Write powershell commands to $Line"
        } | ConvertTo-Json
    }

    $Response = Invoke-WebRequest @RequestParams

    # Best Fit
    $Result = $Response.Content | ConvertFrom-Json
    return $Result.choices[0].text
}
