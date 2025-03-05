function Get-NLPowerShellExplanation {
    param (
        [Parameter(Mandatory)]
        [string] $Line
    )

    # Return null if no line was given
    if (-not $PSBoundParameters.ContainsKey("Line")) { return $null }

    # Extract individual commands from pipelines
    $Commands = $Line -split '\s*\|\s*'

    # Fetch help for each command in the pipeline (up to 3 to keep it concise)
    $HelpTexts = $Commands[0..2] | ForEach-Object { Get-CommandHelpText -Command $_ }

    # Combine help information
    $HelpContext = $HelpTexts -join "`n---`n"

    # Construct AI Prompt
    $Prompt = @"
Explain the following PowerShell command in a concise, imperative manner.
Provide a short explanation if it's simple, or a step-by-step breakdown if it's complex.

$(if ($HelpContext) { "Reference Help Information:`n$HelpContext" } else { "" })

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

Input: ls -Force | Select-Object Name, Length
Output: List all files, including hidden ones, showing only their name and size

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
