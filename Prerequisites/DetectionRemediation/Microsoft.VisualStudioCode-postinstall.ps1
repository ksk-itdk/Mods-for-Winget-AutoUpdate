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
## MARK: Post-Update
##================================================
$adtSession.InstallPhase = 'Post-Update'
$saiwParams = @{
	AllowDefer = $true
	DeferTimes = 3
	CheckDiskSpace = $true
	PersistPrompt = $true
	Title = "$(($adtSession).AppName) - Updating"
	Subtitle = "$Companyname - Automatic Pathing"
	
}

Close-ADTInstallationProgress
Close-ADTSession
