<#
.SYNOPSIS
    Write the NLPowerShell configuration to a file
#>
function Export-NLPowerShellConfig(
    [Parameter(Mandatory)]
    [string] $Path
) {
    if ($Path.EndsWith("json")) {
        $Script:CONFIG.SaveJSON($Path)
    }
    elseif ($Path.EndsWith("xml")) {
        $Script:CONFIG.SaveClixml($Path)
    }
    else {
        Write-Error -Message "Unsupported file-format $Extension"
        return
    }
}
