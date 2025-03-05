# Import PowerShell Scripts
Get-ChildItem -Path $PSScriptRoot -Recurse -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force
}

Initialize-NLPowerShell -Ollama -Model "qwen2.5-coder"
