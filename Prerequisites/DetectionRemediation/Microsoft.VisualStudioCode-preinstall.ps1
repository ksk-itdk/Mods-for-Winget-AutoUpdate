##================================================
## MARK: Initialization
##================================================

if (-not (Get-Module -Name PSAppDeployToolkit)) {
    try {
        Import-Module -Name 'C:\temp\psappdeploytoolkit.4.1.8\PSAppDeployToolkit.psd1' -ErrorAction Stop
    } catch {
        Write-Error "Failed to import PSAppDeployToolkit: $_"
        exit 1
    }
}

$Companyname = 'Banking Circle'
#Get-Command -Module PSAppDeployToolkit

$adtSession = @{
    # App variables.
    AppVendor = 'Automatic Pathing'
    AppName = 'VS Code'
    AppVersion = ''
    AppArch = ''
    AppLang = 'EN'
    AppRevision = '01'
    AppSuccessExitCodes = @(0)
    AppRebootExitCodes = @(1641, 3010)
    AppProcessesToClose = @{ Name = 'Notepad'; Description = 'Notepad' }  # Example: @('excel', @{ Name = 'winword'; Description = 'Microsoft Word' })
	#InstallName = 'VS Code'
    #InstallTitle = 'VS Code'
}

$adtSession = Remove-ADTHashtableNullOrEmptyValues -Hashtable $adtSession
#Open-ADTSession @adtSession -SessionState $ExecutionContext.SessionState -DeploymentType "Install" -DeployMode "Interactive"
Open-ADTSession @adtSession -PassThru

##================================================
## MARK: Pre-Update
##================================================
$adtSession.InstallPhase = 'Pre-Update'
$saiwParams = @{
	AllowDefer = $true
	DeferTimes = 3
	CheckDiskSpace = $true
	PersistPrompt = $true
	Title = "$(($adtSession).AppName) - Updating"
	Subtitle = "$Companyname - Automatic Pathing"
	
}
if ($adtSession.AppProcessesToClose) {
	$processfoundcount = 0
	foreach($apptoclose in (($adtSession).AppProcessesToClose).Name) {
		If(Get-Process -ProcessName $apptoclose -ErrorAction SilentlyContinue){
			$processfoundcount += 1
		}
	}
	if($processfoundcount){
		If(Test-ADTPowerPoint){
			Close-ADTSession -ExitCode 1618
		}
		$saiwParams.Add('CloseProcesses', $adtSession.AppProcessesToClose)
		Show-ADTInstallationWelcome @saiwParams
		Show-ADTInstallationProgress -Title $saiwParams.Title -Subtitle $saiwParams.Subtitle
	}
}


foreach ($process in (Get-CimInstance Win32_Process -Filter "name = 'dllhost.exe'")) {
	if ($process.CommandLine -match "$([regex]::Escape('/Processid:{1C6DF0C0-192A-4451-BE36-6A59A86A692E}'))" ) {
		Stop-Process -Id $process.ProcessId -Force -ErrorAction Stop
	}
}
