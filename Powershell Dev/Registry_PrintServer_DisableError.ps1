<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.165
	 Created on:   	10/8/2019 9:31 AM
	 Created by:   	grlewis
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


Get-ChildItem -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Print\Monitors\Standard TCP/IP Port\Ports' |
select -First 50 | Get-ItemProperty -Name 'SNMP Enabled' | Where-Object { $_.'SNMP Enabled' -eq 1 } |
foreach-object { Set-ItemProperty -Path $_.PSPath -Name 'SNMP Enabled' -Value 0 }