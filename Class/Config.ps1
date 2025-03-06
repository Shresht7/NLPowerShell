<#
.SYNOPSIS
    Configuration class for the NLPowerShell module
.DESCRIPTION
    Stores settings for the natural language-powered PowerShell interface.
    This class supports different AI providers (Ollama and OpenAI) and allows users to configure model parameters.
#>
class Config {
    # Defines the AI provider being used. Defaults to "ollama". Possible values: "ollama", "openai"
    [string] $Provider = "ollama"
    # Defines which AI model will be used for processing input. Example: "gpt-4", "gpt-3.5-turbo-instruct", "llama3.2"
    [string] $Model

    # Defines the API endpoint URL for Ollama. Defaults to "http://localhost:11434"
    [string] $URL = "http://localhost:11434"

    # OpenAI API Key for authentication
    [securestring] $API_KEY
    # OpenAI Organization ID
    [string] $Organization
    # Number of responses to generate. Specifies how many completions to return for a request. (Default 1)
    [double] $N = 1
    
    # Maximum number of tokens for a response. Limits the length of responses from the model.
    [int] $MaxTokens = 64
    # Sampling temperature for AI responses. Higher values (e.g., 1.0) make responses more random. Lower values (e.g., 0.1) make responses more focused. Default: 0.1
    [double] $Temperature = 0.1
    # Top-P (Nucleus Sampling). Controls randomness in responses by considering cumulative probability mass. Default 1
    [double] $TopP = 1

    # Constructor: Initialize from hash-table
    Config([hashtable] $Settings) {
        if ($Settings.Provider) { $this.Provider = $Settings.Provider }
        if ($Settings.Model) { $this.Model = $Settings.Model }
        if ($Settings.URL) { $this.URL = $Settings.URL }
        if ($Settings.API_KEY) { $this.API_KEY = $Settings.API_KEY -as [securestring] }
        if ($Settings.Organization) { $this.Organization = $Settings.Organization }
        if ($Settings.N) { $this.N = $Settings.N }
        if ($Settings.MaxTokens) { $this.MaxTokens = $Settings.MaxTokens }
        if ($Settings.Temperature) { $this.Temperature = $Settings.Temperature }
        if ($Settings.TopP) { $this.TopP = $Settings.TopP }
    }

    # Constructor: Empty
    Config() {}

    <#
    .SYNOPSIS
        Update configuration properties
    .DESCRIPTION
        Accepts a hashtable containing property names and values and updates the current configuration
    .PARAMETER Settings
        A hashtable where keys match property names
    #>
    Update([hashtable] $Settings) {
        if ($Settings.Provider) { $this.Provider = $Settings.Provider }
        if ($Settings.Model) { $this.Model = $Settings.Model }
        if ($Settings.URL) { $this.URL = $Settings.URL }
        if ($Settings.API_KEY) { $this.API_KEY = $Settings.API_KEY -as [securestring] }
        if ($Settings.Organization) { $this.Organization = $Settings.Organization }
        if ($Settings.N) { $this.N = $Settings.N }
        if ($Settings.MaxTokens) { $this.MaxTokens = $Settings.MaxTokens }
        if ($Settings.Temperature) { $this.Temperature = $Settings.Temperature }
        if ($Settings.TopP) { $this.TopP = $Settings.TopP }
    }

    <#
    .SYNOPSIS
        Saves the current configuration to a file in Clixml format
    .PARAMETER
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
        Converts the configuration to JSON. The API is converted from a securestring to its encrypted string representation
    .PARAMETER Path
        The path to the JSON configuration file
    #>
    SaveJSON([string] $Path) {
        # Create a copy to avoid modifying the original object
        $copy = [ordered]@{}
        foreach ($prop in $this.PSObject.Properties) {
            if ($prop.Name -eq 'API_KEY' -and $this.API_KEY) {
                # Convert SecureString to an encrypted string
                $copy[$prop.Name] = ConvertFrom-SecureString -SecureString $this.API_KEY
            }
            else {
                $copy[$prop.Name] = $prop.Value
            }
        }
    
        # Convert to JSON and write to file
        $json = $copy | ConvertTo-Json -Depth 3
        $json | Set-Content -Path $Path -Encoding UTF8 -Force
    }

    <#
    .SYNOPSIS
        Loads the configuration from a JSON file
    .DESCRIPTION
        Reads the JSON file and reconstructs a Config object. The API key os converted from an encrypted string to a secure string
    .PARAMETER Path
        The path to the JSON configuration file
    .OUTPUTS
        Returns a Config object
    #>
    static [Config] LoadJSON([string] $Path) {
        if (-not (Test-Path -Path $Path)) { return [Config]::new() }
    
        $json = Get-Content -Path $Path -Raw | ConvertFrom-Json
        $cfg = [Config]::new()
    
        foreach ($prop in $json.PSObject.Properties) {
            if ($prop.Name -eq 'API_KEY' -and $prop.Value) {
                # Convert the encrypted string back to a SecureString
                $cfg.API_KEY = ConvertTo-SecureString -String $prop.Value
            }
            else {
                $cfg.$($prop.Name) = $prop.Value
            }
        }
    
        return $cfg
    }
    
}

