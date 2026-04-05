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
    [int] $MaxTokens = 64

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
    Specialized Ollama Provider using the OpenAI-compatible endpoint
.DESCRIPTION
    This provider is specifically for the Ollama API.
    It sets the base URL to the Ollama API endpoint and requires a model name.
     Ollama's API is OpenAI-compatible, so it can use the same logic as the OpenAI provider.
#>
class OllamaProvider : OpenAICompatibleProvider {
    OllamaProvider([string] $URL, [string] $Model) {
        $this.BaseUrl = "$($URL.TrimEnd('/'))/v1"
        $this.Model = $Model
    }
    OllamaProvider() {
        $this.BaseUrl = "http://localhost:11434/v1"
    }
}
