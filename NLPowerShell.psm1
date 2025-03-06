# Import PowerShell Scripts
Get-ChildItem -Path $PSScriptRoot -Recurse -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force
}
