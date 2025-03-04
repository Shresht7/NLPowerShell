<#
.SYNOPSIS
    Converts a natural language prompt to a PowerShell command
.DESCRIPTION
    The Get-CommandCompletion function takes a natural language prompt as input
    and uses the OpenAI API to generate a corresponding PowerShell command
.NOTES
    This function uses the OpenAI API to generate the PowerShell command.
    You must provide a valid API key and model name in the CONFIG script variable to use this function.
#>
function Get-NLPowerShellCommand(
    # The natural language prompt to convert to a PowerShell command
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Alias("Line")]
    [string] $Comment
) {
    # Return null if no comment was given
    if (-not $PSBoundParameters.ContainsKey("Comment")) { return $null }

    # The prompt for OpenAI
    $Prompt = "
        <# PowerShell #>
        You have to write a valid command that runs in PowerShell to perform the given task.
        For example, for the following prompt:
        Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
        Your response should be:
        Get a list of the 5 most CPU intensive processes

        Command:
        $Comment
    "

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
