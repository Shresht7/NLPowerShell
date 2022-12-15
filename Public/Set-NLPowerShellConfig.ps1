<#
.SYNOPSIS
    Update the NLPowerShell Config File
.DESCRIPTION
    Update the NLPowerShell Config File.
    The config file keeps track of the `API_KEY` and `Organization`;
    and parameters like `Model Name`, `Max Tokens`, `Temperature`, and `N`.
.EXAMPLE
    Set-NLPowerShellConfig -API_KEY $API_KEY -Organization $Organization
.EXAMPLE
    Set-NLPowerShellConfig -API_KEY $API_KEY -Organization $Organization -ModelName "text-davinci-003" -MaxTokens 64 -Temperature 0.1 -N 1
#>
function Set-NLPowerShellConfig(
    # OpenAI `API_KEY` for authentication. This is used to make api requests.
    # The `API_KEY` is a **secret**. _Do not expose it as plain-text_
    [securestring] $API_KEY,

    # Users can belong to multiple organizations, you can specify which
    # organization is used for an API request. Usage from these API requests will count
    # against the specified organization's subscription quota.
    [string] $Organization,

    # ID of the model to use.
    [Alias("Name", "Model")]
    [string] $ModelName = "text-davinci-003",

    # The maximum number of tokens to generate in the completion.
    # The token count of your prompt + the max tokens cannot exceed the model's context length.
    # Most models have a context length of 2048 tokens (except for the newest models that have 4096)
    [ValidateRange(0, 4096)]
    [int] $MaxTokens = 64,

    # The sampling temperature to use. Higher values means the model will take more risks.
    # Try 0.9 for more creative applications, and 0 for ones with a well-defined answer.
    [ValidateRange(0, 1)]
    [double] $Temperature = 0.1,

    # How many completions to generate for each prompt.
    # Note: Because this parameters generates many completions, it can quickly consume your token quota.
    # Use carefully and ensure that you have reasonable settings for `$MaxTokens` and `$Stop`.
    [Alias("Count", "Number")]
    [int] $N = 1
) {
    # Initialize the $Config object or read from the file-system (if it exists)
    $Config = if (-Not (Test-Path -Path $Script:CONFIG_PATH)) {
        [PSCustomObject]@{
            API_KEY             = $API_KEY
            OpenAI_Organization = $Organization
            Model_Name          = $ModelName
            Max_Tokens          = $MaxTokens
            Temperature         = $Temperature
            N                   = $N
        }
    }
    else {
        Import-Clixml -Path $Script:CONFIG_PATH
    }

    # Set the API_KEY
    if ($API_KEY) { $Config.API_KEY = $API_KEY }

    # Set the Organization
    if ($Organization) { $Config.OpenAI_Organization = $Organization }

    # Set the Model Name
    if ($ModelName) { $Config.Model_Name = $ModelName }

    # Set the Maximum Number of Tokens
    if ($MaxTokens) { $Config.Max_Tokens = $MaxTokens }

    # The temperature value
    if ($Temperature) { $Config.Temperature = $Temperature }

    # The number of completions
    if ($N) { $Config.N = $N }

    # Export to file-system
    $Script:CONFIG = $Config
    $Script:CONFIG | Export-Clixml -Path $Script:CONFIG_PATH
}
