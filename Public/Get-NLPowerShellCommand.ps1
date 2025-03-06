<#
.SYNOPSIS
    Converts a natural language prompt into a PowerShell command.
.DESCRIPTION
    This function takes a natural language description of a task and generates a valid PowerShell command.
    It uses the configured AI provider (Ollama or OpenAI) to generate the command.
.EXAMPLE
    Get-NLPowerShellCommand -Comment "List the 5 most CPU-intensive processes"
    Returns: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
.NOTES
    Requires a valid AI provider, model, and API key to be configured in $Script:CONFIG.
#>
function Get-NLPowerShellCommand(
    # A natural language description of the desired task.
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [Alias("Line")]
    [string] $Comment,
    
    # (Optional) A specific command to retrieve help information for.
    [string] $Command
) {
    # Retrieve help info if a command is provided
    $HelpText = if ($Command) { Get-CommandHelpText -Command $Command } else { @() }
    $HelpText = $HelpText -join "`n"

    # Construct AI Prompt
    $Prompt = @"
You are a PowerShell assistant. Convert the following natural language request into a valid PowerShell command.
Provide only the command itself—no explanations or formatting.
    
$(if ($HelpText) { "Here is some help information related to the command:`n$HelpText" } else { "" })

Example:
Input: # List the 5 most CPU-intensive processes
Output: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

Example:
Input: # Stage all changes and amend them into the last commit
Output: git amend -a --no-edit

Example:
Input: # Search for the word: TODO
Output: rg TODO

Example:
Input: # Open the downloads folder
Output: explorer ~\Downloads

Example:
Input: # What other devices are on my network?
Output: Get-NetIPAddress | Format-Table

Example:
Input: # Find the location of the executable: git
Output: which git

Example:
Input: # What's running on port 1080?
Output: Get-Process -Id (Get-NetTCPConnection -LocalPort 1080).OwningProcess

Example:
Input: # Show me the disk usage of my computer
Output: Get-WmiObject -Class Win32_LogicalDisk | Select-Object -Property DeviceID,FreeSpace,Size,DriverType | Format-Table -AutoSize

Example:
Input: # Interactively stage files in git
Output: git status --short | fzf --multi  --preview "bat {2}" --preview-window "right:70%" | cut -f 2

Example:
Input: # Interactively select and remove git branches
Output: git branch -D (git branch --format="%(refname:short)" | fzf --multi)

Input: $Comment
Output:
"@

    # Select AI Provider
    switch ($Script:CONFIG.Provider) {
        "ollama" { return Invoke-OllamaCompletion -Prompt $Prompt }
        "openai" { return Invoke-OpenAICompletion -Prompt $Prompt }
        Default {
            Write-Error -Message "Invalid or missing AI provider in configuration."
            return $null
        }
    }
}
