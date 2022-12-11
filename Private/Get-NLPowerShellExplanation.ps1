function Get-NLPowerShellExplanation([string] $Line) {
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
            prompt = "Explain the following powershell command in a single line:`n$Line"
        } | ConvertTo-Json
    }

    $Response = Invoke-WebRequest @RequestParams

    # Best Fit
    $Result = ($Response.Content | ConvertFrom-Json).choices[0]
    return $($Result.text)
}
