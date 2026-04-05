# Explicitly import Classes
Get-ChildItem -File -Path (Join-Path $PSScriptRoot "Class") -Filter "*.ps1" | ForEach-Object {
    . $_.FullName -Force
}

# Import Private Helpers
Get-ChildItem -File -Path (Join-Path $PSScriptRoot "Private") -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName -Force
}

# Import Public Functions
Get-ChildItem -File -Path (Join-Path $PSScriptRoot "Public") -Filter "*.ps1" -Recurse | ForEach-Object {
    . $_.FullName -Force
}
