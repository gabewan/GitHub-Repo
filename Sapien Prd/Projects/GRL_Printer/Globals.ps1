#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

[version]$global:VERSION = [System.Windows.Forms.Application]::ProductVersion
[bool]$Global:boolUpdateAvailable = $false
# Currently a test path
[string]$global:strVersionFilePath = '\\hqsbisilon1\filesrv1\its\ITS Desktop Support\GRLEWIS\Applications\GRL_Printer_Version.txt'
[System.Windows.Forms.MessageBox]::Show("$global:VERSION")
function Check-ForUpdate
{
	try
	{
		$readerFileRead = [System.IO.StreamReader]::new($strVersionFilePath)
		$strVersionFileContent = $readerFileRead.ReadToEnd()
		$readerFileRead.Close()
		$readerFileRead.Dispose()
	}
	catch
	{
		Write-Verbose 'Unable to open file path'
		$Global:boolUpdateAvailable = $false
		return $null
	}
	if ($strVersionFileContent -match '\d+\.\d+\.\d+\.\d+')
	{
		[version]$versionLatest = $strVersionFileContent
		
		if ($versionLatest -gt $global:VERSION)
		{
			$Global:boolUpdateAvailable = $true
			
			return $true
		}
		
	}
	else
	{
		$Global:boolUpdateAvailable = $false
		return $null
	}
}
function Start-Update
{
	$strUpdateScriptPath = "$($ENV:TEMP)\AITupdate.ps1"
	$scriptStartUpdate = {
		param (
			[Parameter(Mandatory = $true)]
			$CurrentExecutable = $args[0]
		)
		if (Get-Process 'GRL_Printer')
		{
			Get-Process 'GRL_Printer' | Stop-Process -Force
		}
		# Currently a test path
		$NewExecutable = & '\\hqsbisilon1\filesrv1\its\ITS Desktop Support\GRLEWIS\Applications\GRL_Printer.exe'
		$strUpdateScriptPath = "$($ENV:TEMP)\AITupdate.ps1"
		Copy-Item -Path "$($NewExecutable)" -Destination "$($CurrentExecutable)" -Force
		Start-Process "$($NewExecutable)"
		Write-Host "Current: $CurrentExecutable"
		Write-Host "New: $NewExecutable"
	}
	try
	{
		Set-Content -Path $strUpdateScriptPath -Value $scriptStartUpdate -Force
	}
	catch
	{
	}
	if (Test-Path $strUpdateScriptPath)
	{
		Start-Process powershell -ArgumentList "-file `"$strUpdateScriptPath`" `"$Global:ExecutableLocation`"" -NoNewWindow
	}
}
function Get-ExecutableLocation
{
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		return $hostinvocation.MyCommand.path
	}
	else
	{
		return $script:MyInvocation.MyCommand.Path
	}
}

[string]$Global:ExecutableLocation = Get-ExecutableLocation

function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

function Write-Log
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Message
	)
	
	try
	{
		$DateTime = Get-Date -Format 'MM-dd-yy HH:mm:ss'
		$Invocation = "$($MyInvocation.MyCommand.Source | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)"
		Add-Content -Value "$DateTime - $Invocation - $Message" -Path "\\hqsbvnxfile1\global\Grlewis\Print Application\Log.csv"
	}
	catch
	{
		Write-Error $_.Exception.Message
	}
}


#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory



