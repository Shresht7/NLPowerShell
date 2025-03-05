class Config {
    [string] $Provider = "ollama"
    [string] $Model
    [string] $URL = "http://localhost:11434"
    [securestring] $API_KEY
    [string] $Organization
    [int] $MaxTokens
    [double] $Temperature
    [double] $TopP
    [double] $N
}
