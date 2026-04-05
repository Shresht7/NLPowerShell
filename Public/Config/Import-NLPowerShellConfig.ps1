<#
.SYNOPSIS
    Read the NLPowerShell configuration from a file.
.DESCRIPTION
    Loads the configuration from a JSON or XML file and sets $Script:CONFIG.
    Defaults to the platform-specific default path if no path is provided.
.PARAMETER Path
    The file path where the configuration should be loaded from. Must be .json or .xml.
#>
function Import-NLPowerShellConfig(
    [string] $Path = ([Config]::GetDefaultPath())
) {
    # Ensure the file exists before proceeding
    if (-not (Test-Path -Path $Path)) {
        Write-Error "Configuration file not found: $Path"
        return
    }

    # Get file extension (case-insensitive)
    $Extension = [System.IO.Path]::GetExtension($Path).ToLower()

    # Load configuration based on file type
    switch ($Extension) {
        ".json" {
            try {
                $Config = [Config]::LoadJSON($Path)
                if ($null -eq $Config) { throw "Failed to load JSON configuration." }
                $Script:CONFIG = $Config
                Write-Host "Configuration loaded successfully from $Path (JSON format)"
                return $Config
            }
            catch {
                Write-Error "Error loading JSON configuration: $_"
            }
        }
        ".xml" {
            try {
                $Config = [Config]::LoadClixml($Path)
                if ($null -eq $Config) { throw "Failed to load XML configuration." }
                $Script:CONFIG = $Config
                Write-Host "Configuration loaded successfully from $Path (XML format)"
                return $Config
            }
            catch {
                Write-Error "Error loading XML configuration: $_"
            }
        }
        default {
            Write-Error "Unsupported file format '$Extension'. Supported formats: .json, .xml"
        }
    }
}
