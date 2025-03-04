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
    # Invoke the completion based on the provider
    switch ($Script:CONFIG.LLM_Provider) {
        "ollama" {
            $Response = Invoke-OllamaCompletion -Prompt $Prompt
        }
        "openai" { 
            $Response = "Response from OpenAI"
    # $Response = Invoke-OpenAICompletion -Prompt $Prompt
        }
        Default {
            # Default to ollama
    $Response = Invoke-OllamaCompletion -Prompt $Prompt
        }
    }

    return $Response
}
