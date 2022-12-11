# GLOBAL VARIABLES
$Script:CONFIG = $null
$Script:CONFIG_PATH = "$PSScriptRoot\.openairc"

# Import PowerShell Scripts
Get-ChildItem -Path . -Recurse -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force
}

# Do not register PSReadLineKeyHandler if the config file does not exist
if (-Not (Test-Path -Path $Script:CONFIG_PATH)) { return }

# Import the config file
$Script:CONFIG = Import-Clixml -Path $Script:CONFIG_PATH
    
# Register the PSReadLineKeyHandler
Set-PSReadLineKeyHandler -Key "Ctrl+Shift+RightArrow" `
    -BriefDescription "Natural Language to PowerShell" `
    -LongDescription "Convert Natural Language to PowerShell using OpenAI" `
    -ScriptBlock {
    param ($Key, $Arg)

    $Line = $null
    $Cursor = $null

    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)

    # Exit if not a comment
    if (-Not $Line.StartsWith("#")) { return }

    # get response from Get-Completion function
    $Output = Get-Completion -Line $Line
    
    # exit if the output is null
    if ($null -eq $Output) { return }

    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
    foreach ($Str in $Output) {
        if ($null -ne $Str -and $Str -ne "") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Str)
        }
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" $Line")
}
