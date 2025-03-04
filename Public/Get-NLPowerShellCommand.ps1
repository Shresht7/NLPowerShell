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
    $Prompt = "<# PowerShell #>`n# Write a PowerShell command to do the following:`n$Comment`n"

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
