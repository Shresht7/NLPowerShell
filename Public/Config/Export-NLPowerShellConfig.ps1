<#
.SYNOPSIS
    Write the NLPowerShell configuration to a file.
.DESCRIPTION
    Exports the current configuration to a JSON or XML file.
.PARAMETER Path
    The file path where the configuration should be saved. Must be .json or .xml.
#>
function Export-NLPowerShellConfig(
    [Parameter(Mandatory)]
    [string] $Path
) {
    # Ensure $Script:CONFIG exists
    if ($null -eq $Script:CONFIG) {
        Write-Error "Configuration object is not set. Cannot export."
        return
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
