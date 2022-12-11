function Get-Completion([string] $Line) {
    return "Hello World"
}

Set-PSReadLineKeyHandler -Key "Ctrl+Shift+RightArrow" `
    -BriefDescription "Natural Language to PowerShell" `
    -LongDescription "Convert Natural Language to PowerShell using OpenAI" `
    -ScriptBlock {
    param ($Key, $Arg)

    $Line = $null
    $Cursor = $null

    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)

    # get response from create_completion function
    $Output = Get-Completion -Line $Line
    
    # exit if the output is null
    if ($null -eq $Output) { return }

    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
    foreach ($Str in $Output) {
        if ($Str -ne $null -and $Str -ne "") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Str)
        }
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" $Line")
}
