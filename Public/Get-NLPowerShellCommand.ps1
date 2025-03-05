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
    [string] $Comment,

    [string] $Command
) {
    # Default HelpText to empty
    $HelpText = Get-CommandHelpText -Command $Command -IncludeAll

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
Input: # What other devices are on my network?
Output: Get-NetIPAddress | Format-Table

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

function Get-CommandHelpText {
    param (
        [string] $Command,
        [switch] $IncludeAll  # If true, fetches help for all commands in a pipeline
    )

    if (-not $Command) {
        return ""
    }

    # Split pipeline (`|` or `||` for robustness)
    $Commands = $Command -split '\s*\|\s*'

    if ($IncludeAll) {
        # Get help for each command in the pipeline
        $HelpTexts = $Commands | ForEach-Object { Get-SingleCommandHelp $_ }
        return $HelpTexts -join "`n---`n"
    }
    else {
        # Get help for the right-most command
        return Get-SingleCommandHelp $Commands[-1]
    }
}

function Get-SingleCommandHelp {
    param ([string] $Cmd)

    $CommandInfo = Get-Command $Cmd -ErrorAction SilentlyContinue

    if ($CommandInfo -and $CommandInfo.CommandType -in @('Cmdlet', 'Function')) {
        return Get-Help $Cmd -Full | Out-String
    }
    elseif ($CommandInfo -and $CommandInfo.CommandType -eq 'Application') {
        try {
            $HelpText = & $Cmd --help 2>&1 | Out-String
            if (-not $HelpText) { $HelpText = & $Cmd -h 2>&1 | Out-String }
            return $HelpText
        }
        catch {
            return "No help available for $Cmd."
        }
    }
    else {
        return "Unknown command: $Cmd"
    }
}
