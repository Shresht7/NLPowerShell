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

    if ($Line.StartsWith("#")) {
        # get response from the Get-NLPowerShellCommand function
        $Output = Get-NLPowerShellCommand -Line $Line
        
        # exit if the output is null
        if ($null -eq $Output) { return }
    
        [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteLine()
        foreach ($Str in $Output) {
            if ($null -ne $Str -and $Str -ne "") {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($Str)
            }
        }
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    $Line")
    }
    else {
        # get response from the Get-NLPowerShellExplanation function
        $Output = Get-NLPowerShellExplanation -Line $Line

        # exit if the output is null
        if ($null -eq $Output) { return }

        foreach ($Str in $Output) {
            if ($null -ne $Str -and $Str -ne "") {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert("    # $Str")
            }
        }
    }

}
