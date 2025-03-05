<#
.SYNOPSIS
    Configuration class for the NLPowerShell module.
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

    # API Key for authentication (OpenAI only).
    [securestring] $API_KEY
    # OpenAI Organization ID
    [string] $Organization
    # Number of responses to generate. Specifies how many completions to return for a request. (Default 1)
    [double] $N = 1
    
    # Maximum number of tokens for a response. Limits the length of responses from the model.
    [int] $MaxTokens
    # Sampling temperature for AI responses. Higher values (e.g., 1.0) make responses more random. Lower values (e.g., 0.1) make responses more focused. Default: 0.1
    [double] $Temperature = 0.1
    # Top-P (Nucleus Sampling). Controls randomness in responses by considering cumulative probability mass. Default 1
    [double] $TopP = 1
}
