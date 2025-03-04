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
    $Prompt = "
        Explain, using imperative speech, the following PowerShell command in one single line using as few words as possible.
        This is running inside a terminal environment and the output will be placed next to the input in the prompt as a comment.
        For example, for:
        Get-Command | Get-Random | Get-Help -Full
        you should respond with:
        Retrieve a random command and display its full help information

        Here the input:
        $Line
    "

    # Idea: It might be cool to pass in the --help text (if possible) along with the context

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
