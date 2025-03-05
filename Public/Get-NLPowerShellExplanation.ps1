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
    $Prompt = @"
Explain, using imperative speech, the following PowerShell command in one single line using as few words as possible.
This is running inside a terminal environment and the output will be placed next to the input in the prompt as a comment.

Example:
Input: Get-Command | Get-Random | Get-Help -Full
Output: Retrieve a random command and display its full help information

Example:
Input: git switch (git list-branch | fzf)
Output: Interactively switch git branch

Input: $Line
Output:
"@

    # Invoke the completion based on the provider
    switch ($Script:CONFIG.Provider) {
        "ollama" {
            $Response = Invoke-OllamaCompletion -Prompt $Prompt
        }
        "openai" { 
            $Response = Invoke-OpenAICompletion -Prompt $Prompt
        }
        Default {
            Write-Error -Message "Unsupported Provider: $($Script:CONFIG.Provider)"
            return 
        }
    }
    
    return $Response
}
