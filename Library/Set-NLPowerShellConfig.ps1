<#
.SYNOPSIS
    Update the NLPowerShell Config File
.DESCRIPTION
    Update the NLPowerShell Config File
#>
function Set-NLPowerShellConfig(
    # OpenAI API_KEY for authentication. This is used to make api requests.
    # The API_KEY is a secret. Do not expose it as plain-text
    [securestring] $API_KEY,

    # (Optional) Users can belong to multiple organizations, you can specify which
    # organization is used for an API request. Usage from these API requests will count
    # against the specified organization's subscription quota.
    [string] $Organization
) {
    # Initialize the $Config object or read from the file-system (if it exists)
    $Config = if (-Not (Test-Path -Path $Script:CONFIG_PATH)) {
        [PSCustomObject]@{}
    }
    else {
        Import-Clixml -Path $Script:CONFIG_PATH
    }

    # Set the API_KEY
    if ($API_KEY) {
        $Config.API_KEY = $API_KEY
    }

    # Set the Organization
    if ($Organization) {
        $Config.ORGANIZATION = $Organization
    }

    # Export to file-system
    $Script:CONFIG = $Config
    $Script:CONFIG | Export-Clixml -Path $Script:CONFIG_PATH
}
