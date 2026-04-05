<#
.SYNOPSIS
    Gathers non-sensitive context about the current PowerShell environment
.DESCRIPTION
    Retrieves OS, Shell version, and a summarized file list
    to provide  grounding for AI completions.
#>
function Get-EnvironmentContext {
    $Context = [ordered]@{}

    # OS and Shell Version
    $Context["OS"] = [System.Runtime.InteropServices.RuntimeInformation]::OSDescription
    $Context["PowerShell"] = $PSVersionTable.PSVersion.ToString()

    # Privacy-aware Working Directory
    # Replaces the user's home path (e.g., C:\Users\John) with ~
    $CurrentPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    $HomePath = $HOME
    if ($CurrentPath.StartsWith($HomePath)) {
        $Context["Directory"] = $CurrentPath.Replace($HomePath, "~")
    }
    else {
        $Context["Directory"] = $CurrentPath
    }

    # Brief Directory Listing (Names and Types only)
    try {
        $Items = Get-ChildItem -Path . -ErrorAction SilentlyContinue | Select-Object Name, @{
            Name       = "Type"
            Expression = { if ($_.PSIsContainer) { "Directory" } else { "File" } }
        }
        
        if ($Items) {
            # Limit to first 20 items to avoid token bloat
            $List = $Items[0..19] | ForEach-Object { "$($_.Name) ($($_.Type))" }
            $Context["LocalFiles"] = $List -join ", "
        }
    }
    catch {}

    # Convert to a readable string for the prompt
    return $Context.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" } | Out-String
}
