<#
.SYNOPSIS
    Explains a given PowerShell command in natural language.
.DESCRIPTION
    This function takes a PowerShell command and generates a concise explanation.
    If the command contains a pipeline, it provides help for key commands in the pipeline.
.PARAMETER Line
    The PowerShell command to explain.
.EXAMPLE
    Get-NLPowerShellExplanation -Line "Get-Process | Sort-Object CPU -Descending | Select-Object -First 5"
    Returns: "Show the top 5 most CPU-intensive processes"
.NOTES
    Requires a valid AI provider, model, and API key to be configured in $Script:CONFIG.
#>
function Get-NLPowerShellExplanation(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Line
) {
    # Extract individual commands from a pipeline (limit to first 3 for brevity)
    $Commands = $Line -split '\s*\|\s*'
    $HelpTexts = @($Commands[0..([math]::Min(2, $Commands.Count - 1))] | ForEach-Object { Get-CommandHelpText -Command $_ })

    # Construct AI Prompt
    $Prompt = @"
Explain the following PowerShell command in a concise, imperative manner.
Provide a short explanation if it's simple, or a step-by-step breakdown if it's complex.

$(if ($HelpTexts.Count -gt 0) { "Reference Help Information:`n$($HelpTexts -join "`n---`n")" } else { "" })

Examples:

Input: Get-Process -Name notepad
Output: List all running Notepad processes

Input: Get-Content file.txt
Output: Display the contents of 'file.txt'

Input: Stop-Service -Name spooler
Output: Stop the Print Spooler service

Input: git status
Output: Show the status of the current Git repository

Input: curl https://example.com -o page.html
Output: Download 'example.com' and save as 'page.html'

Input: (Get-Date).DayOfWeek
Output: Get the current day of the week

Input: Get-ADUser -Filter "Name -eq '`$(whoami)'"
Output: Retrieve the current Active Directory user details

Input: Get-Service | Where-Object Status -eq "Running"
Output: List all running services

Input: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
Output: Show the top 5 most CPU-intensive processes

Input: Get-ChildItem | Measure-Object -Property Length -Sum
Output: Calculate total size of files in the current directory

Input: Get-Command | Get-Random | Get-Help -Full
Output: Select a random command and display its full help

Input: git switch (git branch | fzf)
Output: Interactively switch to a selected Git branch

Input: $Line
Output:
"@

    # Invoke AI completion
    switch ($Script:CONFIG.Provider) {
        "ollama" { return Invoke-OllamaCompletion -Prompt $Prompt }
        "openai" { return Invoke-OpenAICompletion -Prompt $Prompt }
        Default {
            Write-Error -Message "Invalid or missing AI provider in configuration."
            return $null
        }
    }
}
