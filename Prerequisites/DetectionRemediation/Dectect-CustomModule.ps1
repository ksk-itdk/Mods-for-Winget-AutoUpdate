$ErrorActionPreference = "Stop"

# Config - Detect if custom PowerShell script exists
$ScriptPath = "C:\Windows\KSKIT\psappdeploytoolkit\PSAppDeployToolkit.psm1"

try {
    if (Test-Path -Path $ScriptPath -PathType Leaf) {
        Write-Output "Compliant: $ScriptPath exists."
        exit 0
    } else {
        Write-Output "Non-compliant: $ScriptPath is missing."
        exit 1
    }
}
catch {
    Write-Output "Detection error: $($_.Exception.Message)"
    exit 1
}