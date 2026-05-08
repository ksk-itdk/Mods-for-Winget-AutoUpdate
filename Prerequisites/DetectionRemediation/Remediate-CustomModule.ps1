$ErrorActionPreference = "Stop"

# Config - Download zip from Blob and extract
$BlobZipUrl = "https://yourstorage.blob.core.windows.net/scripts/CustomScripts.zip"
$ExtractPath = "C:\Windows\KSKIT"
$ScriptPath = Join-Path $ExtractPath "PSAppDeployToolkit.psm1"

try {
    # Check if already exists
    if (Test-Path -Path $ScriptPath -PathType Leaf) {
        Write-Output "Already remediated: $ScriptPath exists."
        exit 0
    }

    Write-Output "Downloading zip from Blob..."

    $tempZip = Join-Path $env:TEMP "CustomScripts.zip"
    if (Test-Path $tempZip) {
        Remove-Item $tempZip -Force
    }

    # Download from Blob
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $BlobZipUrl -OutFile $tempZip -UseBasicParsing

    # Create extraction directory if not exists
    if (-not (Test-Path $ExtractPath)) {
        New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null
    }

    # Extract zip
    Write-Output "Extracting to $ExtractPath..."
    Expand-Archive -Path $tempZip -DestinationPath $ExtractPath -Force
    Remove-Item $tempZip -Force

    # Verify
    if (Test-Path -Path $ScriptPath -PathType Leaf) {
        Write-Output "Remediation successful: $ScriptPath extracted."
        exit 0
    } else {
        Write-Output "Remediation failed: script not found after extraction."
        exit 1
    }
}
catch {
    Write-Output "Remediation error: $($_.Exception.Message)"
    exit 1
}