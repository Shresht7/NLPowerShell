<#
.SYNOPSIS
    Write the NLPowerShell configuration to a file
#>
function Export-NLPowerShellConfig(
    [Parameter(Mandatory)]
    [string] $Path
) {
    $Extension = (Get-Item -Path $Path).Extension
    if ($Extension -eq "json") {
        $Script:CONFIG.SaveJSON($Path)
    }
    elseif ($Extension -eq "xml") {
        $Script:CONFIG.SaveClixml($Path)
    }
    else {
        Write-Error -Message "Unsupported file-format $Extension"
        return
    }
}
