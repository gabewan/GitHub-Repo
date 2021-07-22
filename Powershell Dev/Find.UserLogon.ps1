function Find-UserLogon{
#Set variables
$progress = 0

#Get Admin Credentials
Function Get-Login {
Clear-Host
Write-Host "Please provide admin credentials (for example DOMAIN\admin.user and your password)"
$Global:Credential = Get-Credential
}
Get-Login

#Get Username to search for
Function Get-Username {
	Clear-Host
	$Global:Username = Read-Host "Enter username you want to search for"
	if ($Username -eq $null){
		Write-Host "Username cannot be blank, please re-enter username!"
		Get-Username
	}
	$UserCheck = Get-ADUser $Username
	if ($UserCheck -eq $null){
		Write-Host "Invalid username, please verify this is the logon id for the account!"
		Get-Username
	}
}
Get-Username

#Get Computername Prefix for large environments
Function Get-Prefix {
	Clear-Host
	$Global:Prefix = Read-Host "Enter a prefix of Computernames to search on (CXX*) use * as a wildcard or enter * to search on all computers"
	Clear-Host
}
Get-Prefix

#Start search
$computers = Get-ADComputer -Filter {Enabled -eq 'true' -and SamAccountName -like $Prefix}
$CompCount = $Computers.Count
Write-Host "Searching for $Username on $Prefix on $CompCount Computers`n"

#Start main foreach loop, search processes on all computers
foreach ($comp in $computers){
	$Computer = $comp.Name
	$Reply = $null
  	$Reply = test-connection $Computer -count 1 -quiet
  	if($Reply -eq 'True'){
		if($Computer -eq $env:COMPUTERNAME){
			#Get explorer.exe processes without credentials parameter if the query is executed on the localhost
			$proc = gwmi win32_process -ErrorAction SilentlyContinue -computer $Computer -Filter "Name = 'explorer.exe'"
		}
		else{
			#Get explorer.exe processes with credentials for remote hosts
			$proc = gwmi win32_process -ErrorAction SilentlyContinue -Credential $Credential -computer $Computer -Filter "Name = 'explorer.exe'"
		}			
			#If $proc is empty return msg else search collection of processes for username
		if([string]::IsNullOrEmpty($proc)){
			write-host "Failed to check $Computer!"
		}
		else{	
			$progress++			
			ForEach ($p in $proc) {				
				$temp = ($p.GetOwner()).User
				Write-Progress -activity "Working..." -status "Status: $progress of $CompCount Computers checked" -PercentComplete (($progress/$Computers.Count)*100)
				if ($temp -eq $Username){
				write-host "$Username is logged on $Computer"
				}
			}
		}	
	}
}
write-host "Search done!"
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3zTP56W2JMuAA2+ugk/CxG/r
# kKagggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
# AQsFADAbMRkwFwYDVQQDDBBncmxld2lzQG5naHMuY29tMB4XDTE5MDIxODE2MTcz
# N1oXDTIwMDIxODE2MzczN1owGzEZMBcGA1UEAwwQZ3JsZXdpc0BuZ2hzLmNvbTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALW1WUSF3b+IwTQ7gk0Wx5Ap
# 12KUN8LgBQo7IdtDz6HDG/d3EU2gj27qjktOJI9ChnDdp4G5/8hNVPb9s2eIh5ae
# 1Cc/RHwFLu3WlIiEs5p7xbHprqR4gg8J3eEjHcY2FJxf+1NyLeov3CLWYRXfHgef
# ZqI0WJ1PEO6Jv5/VVWw0oMp2Od04PfH/rymHRh0yFSueOmfO/zxKcSM9/21C/n1Y
# B8ffpznvlY0smaikTkC7dubkX6GHU64ZDI69esh/KvPyX0m6e08130aIbaN3me0i
# lNmlBBqA52mVSIarDzY50HQHHF25zqgWqwYs0RSrwO20xwR33l2z7O3MpKZHGgkC
# AwEAAaNjMGEwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBsG
# A1UdEQQUMBKCEGdybGV3aXNAbmdocy5jb20wHQYDVR0OBBYEFB3t05KWOpdR18AN
# FF5Q6CIVBV94MA0GCSqGSIb3DQEBCwUAA4IBAQCU54GYx7ycvM7LHjgchGu2Gwak
# rY2AFJndoGyWB2D/B+uBpI3RxQKWZXaeEpKyUxGWfiFKyHLBfesNyCawzBIzkXxR
# QFZkS532tq9snNHmrX+dhw3cH5/ww/VwWyrvLq19I4wCS+1BTCwJUbetigDv+zlT
# bf/wXP5h13OC6clYRbTq0mTglqYXBlDVjFOwkI6MpvXwoKarggJ1N71HA2TqQpWU
# TA+6WgfEPiZDzpLig5ri6wSu1oVVq+YhP1yPDq+2OQ03SM04GdaUkWVkZnGqS6Ev
# d34IsRreZ6jF5LvSolXkXXfK9/1V11928ne/51iwjgMn7R5V2rhR+EnME6cvMYIB
# 0DCCAcwCAQEwLzAbMRkwFwYDVQQDDBBncmxld2lzQG5naHMuY29tAhBAsfjeyAfg
# gUi73gezXRteMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRya+eP1d9SOeCRTnTu83fINrYycjAN
# BgkqhkiG9w0BAQEFAASCAQAyMS/Qk/onfM/grXRM8b/Lxw1Eq8/ZdDku0nzgz+9S
# VcVX7ojHyCmv3AyJopTzO5DFR8S6sA19Df07coMCw4GijGo2+1O7EEJJwQ46Yla5
# zJTsil/nOzALRXgKUdHTDbIC627VdV7QxZV2+/pPBe54MSwrtf/in7oKgCzp5WAD
# 2W3X2paQWYzXovVU1qp2EzUn78IfeA8QxPsRO492SEutwx5w474CF9m0oQEK0T10
# UU0xy+OAbdIcIYNqhM2HQZMhiiJcUA4UUXwSit/Mp4qdbyyBivF8VEiHv9o53K3i
# QyTPYVSCagr4KkPV3qCadFeLAdnryWbXwU+ygZKtHzyX
# SIG # End signature block
