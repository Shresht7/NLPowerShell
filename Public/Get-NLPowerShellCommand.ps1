<#
.SYNOPSIS
    Converts a natural language prompt into a PowerShell command.
.DESCRIPTION
    This function takes a natural language description of a task and generates a valid PowerShell command.
    It uses the configured AI provider (Ollama or OpenAI) to generate the command.
.PARAMETER Comment
    A natural language description of the desired task.
.EXAMPLE
    Get-NLPowerShellCommand -Comment "List the 5 most CPU-intensive processes"
    Returns: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
.NOTES
    Requires a valid AI provider, model, and API key to be configured in $Script:CONFIG.
#>
function Get-NLPowerShellCommand(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Alias("Line")]
    [string] $Comment
) {
    # Construct AI Prompt
    $Prompt = @"
You are a PowerShell assistant. Convert the following natural language request into a valid PowerShell command.
Provide only the command itself—no explanations or formatting. The command you generate can use external cli tools and is not limited just to PowerShell cmdlets.
    
Example:
Input: # List the 5 most CPU-intensive processes
Output: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

Example:
Input: # Stage all changes and amend them into the last commit
Output: git amend -a --no-edit

Example:
Input: # Interactively stage files in git
Output: git status --short | fzf --multi  --preview "bat {2}" --preview-window "right:70%" | cut -f 2

Input: $Comment
Output:
"@

    # Select Provider and Invoke Completion
    switch ($Script:CONFIG.Provider) {
        "ollama" { $Response = Invoke-OllamaCompletion -Prompt $Prompt }
        "openai" { $Response = Invoke-OpenAICompletion -Prompt $Prompt }
        Default {
            Write-Error -Message "Unsupported Provider: $($Script:CONFIG.Provider)"
            return 
        }
    }

    return $Response
}
