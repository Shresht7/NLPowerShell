<#
.SYNOPSIS
    Returns an explanation of the given line of PowerShell code
.DESCRIPTION
    The Get-NLPowerShellExplanation function returns an explanation
    of the given line of PowerShell code, using the OpenAI API.
.NOTES
    This function uses the OpenAI API to generate the explanation.
    You must provide a valid API key and model name in the CONFIG script variable to use this function.
#>
function Get-NLPowerShellExplanation(
    # The line of PowerShell code to explain
    [Parameter(Mandatory)]
    [string] $Line
) {
    # Return null if no line was given
    if (-not $PSBoundParameters.ContainsKey("Line")) { return $null }

    # The prompt for OpenAI
    $Prompt = "Explain, using imperative speech, the following PowerShell command in a single line:`n$Line"

    # Invoke the OpenAI API
    # $Response = Invoke-OpenAICompletion -Prompt $Prompt
    $Response = Invoke-OllamaCompletion -Prompt $Prompt

    # Get the best-fit result and process it for output
    # $Result = $Response.choices[0].text.Trim()
    $Result = $Response

    return $Result
}
