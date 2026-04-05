<#
.SYNOPSIS
    Write the NLPowerShell configuration to a file.
.DESCRIPTION
    Exports the current configuration to a JSON or XML file. 
    Defaults to the platform-specific default path if no path is provided.
.PARAMETER Path
    The file path where the configuration should be saved. Must be .json or .xml.
#>
function Export-NLPowerShellConfig(
    [string] $Path = ([Config]::GetDefaultPath())
) {
    # Ensure $Script:CONFIG exists
    if ($null -eq $Script:CONFIG) {
        Write-Error "Configuration object is not set. Cannot export."
        return
    }

    # Ensure the directory exists
    $Dir = Split-Path -Path $Path
    if ($Dir -and -not (Test-Path -Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }

    # Get file extension
    $Extension = [System.IO.Path]::GetExtension($Path).ToLower()

    switch ($Extension) {
        ".json" {
            try {
                $Script:CONFIG.SaveJSON($Path)
                Write-Host "Configuration saved to $Path (JSON format)"
            }
            catch {
                Write-Error "Failed to save configuration as JSON: $_"
            }
        }
        ".xml" {
            try {
                $Script:CONFIG.SaveClixml($Path)
                Write-Host "Configuration saved to $Path (XML format)"
            }
            catch {
                Write-Error "Failed to save configuration as XML: $_"
            }
        }
        default {
            Write-Error "Unsupported file format '$Extension'. Supported formats: .json, .xml"
        }
    }
}
