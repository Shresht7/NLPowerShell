<#
.SYNOPSIS
    Read the NLPowerShell configuration from a file
#>
function Import-NLPowerShellConfig(
    [Parameter(Mandatory)]
    [string] $Path
) {
    $Extension = (Get-Item -Path $Path).Extension
    if ($Extension -eq "json") {
        $Script:CONFIG = [Config]::LoadJSON($Path)
    }
    elseif ($Extension -eq "xml") {
        $Script:CONFIG = [Config]::LoadClixml($Path)
    }
    else {
        Write-Error -Message "Unsupported file-format $Extension"
        return
    }
}
