<#
.SYNOPSIS
    Base class for all LLM providers
.DESCRIPTION
    This class defines the common interface and properties for all LLM providers.
    Subclasses should implement the GetCompletion method to provide provider-specific logic.
#>
class LLMProvider {
    # The model name to use for completion
    [string] $Model

    # The maximum number of tokens to generate in the completion
    [int] $MaxTokens = 128

    # The sampling temperature to use for generation (0.0 = deterministic, higher = more random)
    [double] $Temperature = 0.1

    # The nucleus sampling probability (0.0 = only top tokens, 1.0 = all tokens)
    [double] $TopP = 1

    # Constructor
    LLMProvider([string] $Model) {
        $this.Model = $Model
    }

    LLMProvider() {}

    # Abstract-like method to be implemented by subclasses
    [string] GetCompletion([System.Collections.Generic.List[hashtable]] $Messages) {
        throw "GetCompletion not implemented for this provider."
    }

    # Helper to pack common options into a hashtable
    [hashtable] GetOptions() {
        return @{
            MaxTokens   = $this.MaxTokens
            Temperature = $this.Temperature
            TopP        = $this.TopP
        }
    }
}

<#
.SYNOPSIS
    Provider for OpenAI-compatible APIs (OpenAI, Ollama v1, Groq, etc.)
.DESCRIPTION
    This provider can be used with any API that follows the OpenAI Chat Completion API format.
    It requires the base URL of the API, the model name, and an API key for authentication.
#>
class OpenAICompatibleProvider : LLMProvider {
    # The base URL of the API (e.g., https://api.openai.com/v1 or http://localhost:11434/v1)
    [string] $BaseUrl

    # The API key for authentication (stored as a secure string)
    [securestring] $ApiKey

    OpenAICompatibleProvider([string] $BaseUrl, [string] $Model, [securestring] $ApiKey) {
        $this.BaseUrl = $BaseUrl
        $this.Model = $Model
        $this.ApiKey = $ApiKey
    }

    OpenAICompatibleProvider() {}

    # Override the GetCompletion method to call the OpenAI-compatible API endpoint
    [string] GetCompletion([System.Collections.Generic.List[hashtable]] $Messages) {
        return Invoke-ChatCompletion `
            -BaseUrl $this.BaseUrl `
            -Model $this.Model `
            -Messages $Messages `
            -ApiKey $this.ApiKey `
            -Options $this.GetOptions()
    }
}

<#
.SYNOPSIS
    Specialized OpenAI Provider
.DESCRIPTION
    This provider is specifically for the OpenAI API.
    It sets the base URL to the OpenAI API endpoint and requires a model name and API key.
#>
class OpenAIProvider : OpenAICompatibleProvider {
    OpenAIProvider([string] $Model, [securestring] $ApiKey) {
        $this.BaseUrl = "https://api.openai.com/v1"
        $this.Model = $Model
        $this.ApiKey = $ApiKey
    }
    OpenAIProvider() {
        $this.BaseUrl = "https://api.openai.com/v1"
    }
}

<#
.SYNOPSIS
    Specialized Local Provider (Ollama, llama.cpp, etc.) using the OpenAI-compatible endpoint
.DESCRIPTION
    This provider is for local inference engines.
    It defaults to the Ollama endpoint but can be pointed to any OpenAI-compatible local API.
#>
class LocalProvider : OpenAICompatibleProvider {
    LocalProvider([string] $URL, [string] $Model) {
        $this.BaseUrl = "$($URL.TrimEnd('/'))/v1"
        $this.Model = $Model
    }
    LocalProvider() {
        $this.BaseUrl = "http://localhost:11434/v1"
    }
}

<#
.SYNOPSIS
    Configuration class for the NLPowerShell module
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
        Returns the default platform-specific configuration path
    #>
    static [string] GetDefaultPath() {
        $IsWin = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows)
        $Root = if ($IsWin) { 
            Join-Path $env:LOCALAPPDATA "NLPowerShell"
        }
        else { 
            Join-Path $env:HOME ".local" "share" "NLPowerShell"
        }
        return Join-Path $Root "Config.json"
    }

    <#
    .SYNOPSIS
        Saves the current configuration to a file in Clixml format
    #>
    SaveClixml([string] $Path) {
        $this | Export-Clixml -Path $Path -Force
    }

    <#
    .SYNOPSIS
        Loads the configuration from a Clixml file
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
    #>
    SaveJSON([string] $Path) {
        $ConfigData = [ordered]@{
            KeyBind      = $this.KeyBind
            ProviderType = $this.ActiveProvider.GetType().Name
            ProviderData = @{}
        }

        foreach ($prop in $this.ActiveProvider.PSObject.Properties) {
            if ($prop.Name -eq 'ApiKey' -and $prop.Value) {
                $ConfigData.ProviderData[$prop.Name] = ConvertFrom-SecureString -SecureString $prop.Value
            }
            else {
                $ConfigData.ProviderData[$prop.Name] = $prop.Value
            }
        }

        $json = $ConfigData | ConvertTo-Json -Depth 3
        $json | Set-Content -Path $Path -Encoding UTF8 -Force
    }

    <#
    .SYNOPSIS
        Loads the configuration from a JSON file
    #>
    static [Config] LoadJSON([string] $Path) {
        if (-not (Test-Path -Path $Path)) { return [Config]::new() }

        $json = Get-Content -Path $Path -Raw | ConvertFrom-Json
        $cfg = [Config]::new()

        if ($json.KeyBind) { $cfg.KeyBind = $json.KeyBind }

        if ($json.ProviderType -and $json.ProviderData) {
            $Provider = New-Object -TypeName $json.ProviderType
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
