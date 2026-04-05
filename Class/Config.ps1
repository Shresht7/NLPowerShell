using module .\Providers.ps1

<#
.SYNOPSIS
    Configuration class for the NLPowerShell module
.DESCRIPTION
    Stores settings for the natural language-powered PowerShell interface.
    This class supports different AI providers (Ollama and OpenAI) and allows users to configure model parameters.
#>
class Config {
    # The active LLM provider (Ollama, OpenAI, etc.)
    [LLMProvider] $ActiveProvider

    # The keybinding to use to trigger NLPowerShell. Defaults to Ctrl+Shift+Insert
    [string] $KeyBind = "Ctrl+Shift+Insert"

    # Constructor: Empty
    Config() {}

    <#
    .SYNOPSIS
        Saves the current configuration to a file in Clixml format
    .PARAMETER Path
        The path to the configuration file
    #>
    SaveClixml([string] $Path) {
        $this | Export-Clixml -Path $Path -Force
    }

    <#
    .SYNOPSIS
        Loads the configuration from a Clixml file
    .PARAMETER Path
        The path to the configuration file
    .OUTPUTS
        Returns a Config object
    #>
    static [Config] LoadClixml([string] $Path) {
        if (Test-Path -Path $Path) {
            return [Config](Import-Clixml -Path $Path)
        }
        return [Config]::new()
    }

    <#
    .SYNOPSIS
        Saves the current configuration to a file in JSON format
    .DESCRIPTION
        Converts the configuration to JSON. API Keys are converted from SecureString to encrypted strings.
    .PARAMETER Path
        The path to the JSON configuration file
    #>
    SaveJSON([string] $Path) {
        # Create a representation that handles the provider type and serialization
        $ConfigData = [ordered]@{
            KeyBind      = $this.KeyBind
            ProviderType = $this.ActiveProvider.GetType().Name
            ProviderData = @{}
        }

        # Pack provider properties
        foreach ($prop in $this.ActiveProvider.PSObject.Properties) {
            if ($prop.Name -eq 'ApiKey' -and $prop.Value) {
                $ConfigData.ProviderData[$prop.Name] = ConvertFrom-SecureString -SecureString $prop.Value
            }
            else {
                $ConfigData.ProviderData[$prop.Name] = $prop.Value
            }
        }

        # Convert to JSON and write to file
        $json = $ConfigData | ConvertTo-Json -Depth 3
        $json | Set-Content -Path $Path -Encoding UTF8 -Force
    }

    <#
    .SYNOPSIS
        Loads the configuration from a JSON file
    .DESCRIPTION
        Reads the JSON file and reconstructs the Config and ActiveProvider objects.
    .PARAMETER Path
        The path to the JSON configuration file
    .OUTPUTS
        Returns a Config object
    #>
    static [Config] LoadJSON([string] $Path) {
        if (-not (Test-Path -Path $Path)) { return [Config]::new() }

        $json = Get-Content -Path $Path -Raw | ConvertFrom-Json
        $cfg = [Config]::new()

        if ($json.KeyBind) { $cfg.KeyBind = $json.KeyBind }

        if ($json.ProviderType -and $json.ProviderData) {
            # Instantiate the correct provider type
            $Provider = New-Object -TypeName $json.ProviderType
            
            # Populate provider properties
            foreach ($prop in $json.ProviderData.PSObject.Properties) {
                if ($prop.Name -eq 'ApiKey' -and $prop.Value) {
                    $Provider.ApiKey = ConvertTo-SecureString -String $prop.Value
                }
                else {
                    $Provider.$($prop.Name) = $prop.Value
                }
            }
            $cfg.ActiveProvider = $Provider
        }

        return $cfg
    }
}

