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

    # Gather Environment Context
    $EnvContext = Get-EnvironmentContext

    # Define the System Prompt
    $SystemPrompt = @"
You are a PowerShell assistant. Convert the natural language request into a valid PowerShell command.
Provide ONLY the command itself—no explanations, markdown formatting, or preamble. 
Keep the response concise and within a reasonable length for a single terminal command.

Current Session Context:
$EnvContext
$(if ($HelpText) { "`nRelevant Command Help:`n$HelpText" } else { "" })

Examples:

Input: # List the 5 most CPU-intensive processes
Output: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

Input: # Stage all changes and amend them into the last commit
Output: git amend -a --no-edit

Input: # Search for the word: TODO
Output: rg TODO

Input: # Open the downloads folder
Output: explorer ~\Downloads

Input: # What other devices are on my network?
Output: Get-NetIPAddress | Format-Table

Input: # Find the location of the executable: git
Output: which git

Input: # What's running on port 1080?
Output: Get-Process -Id (Get-NetTCPConnection -LocalPort 1080).OwningProcess

Input: # Show me the disk usage of my computer
Output: Get-WmiObject -Class Win32_LogicalDisk | Select-Object -Property DeviceID,FreeSpace,Size,DriverType | Format-Table -AutoSize

Input: # Interactively stage files in git
Output: git status --short | fzf --multi  --preview "bat {2}" --preview-window "right:70%" | cut -f 2

Input: # Interactively select and remove git branches
Output: git branch -D (git branch --format="%(refname:short)" | fzf --multi)
"@

    # Construct the Messages
    $Messages = [System.Collections.Generic.List[hashtable]]::new()
    $Messages.Add(@{ role = "system"; content = $SystemPrompt })
    $Messages.Add(@{ role = "user"; content = "# $Comment" })

    # First Attempt
    if (-not $Script:CONFIG.ActiveProvider) {
        Write-Error "NLPowerShell is not initialized. Please run Initialize-NLPowerShell first."
        return $null
    }
    $SuggestedCommand = $Script:CONFIG.ActiveProvider.GetCompletion($Messages)
    if ($null -eq $SuggestedCommand) { return $null }

    # Validation & Auto-Retry
    $MissingCommands = Test-GeneratedCommand -Script $SuggestedCommand
    if ($MissingCommands.Count -gt 0) {
        Write-Verbose "AI Hallucinated: $($MissingCommands -join ', '). Retrying..."

        # Add the hallucinated command and the error message to the conversation
        $Messages.Add(@{ role = "assistant"; content = $SuggestedCommand })
        $Messages.Add(@{ role = "user"; content = "The following commands do not exist on this system: $($MissingCommands -join ', '). Please provide a valid alternative using only available PowerShell cmdlets or installed CLI tools." })

        # Second Attempt
        $SuggestedCommand = $Script:CONFIG.ActiveProvider.GetCompletion($Messages)
    }

    return $SuggestedCommand
}

