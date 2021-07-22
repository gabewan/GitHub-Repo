<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.165
	 Created on:   	10/9/2019 10:59 AM
	 Created by:   	grlewis
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Review software that is potentially installed on devices through bigfix. 
#>
function Source-Data{
$pass = Read-Host "Enter LDAP Pass"
$ie = New-Object -ComObject internetexplorer.application
Start-Sleep 1
$ie.visible = $false
Start-Sleep 1
#The URL here needs to be the filters applied already. So with mine, it applies "All Devices based on Name and ID"
$ie.Navigate("https://vmwsbigfix01.nghs.com/webreports?page=ExploreComputers#collapseState=&reportInfo=99c8f8cdb40f0ccf9d120bdc1258ee6d01a3df3f&filterManager=6a98d0a803685ce14de7f983d2bbdba11363b6d2&chartSection=&wr_computerTable=002cca41acd3b36027e81dd06141a5d116910166")
#$ie.Navigate("https://vmwsbigfix01.nghs.com/webreports?page=ExploreComputers#collapseState=4e697d7d6da84550505cf4529556ec9692c5cfde&reportInfo=&filterManager=&chartSection=&wr_computerTable=e96171b9b5828dd73ace6e7d243992ec8ce85889")
Start-Sleep 1
$Username_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where { $_.name -eq "username" } -ErrorAction SilentlyContinue
Start-Sleep 1
$Login_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object { $_.type -eq 'submit' }
Start-Sleep 1
$Password_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object { $_.type -eq 'Password' } -ErrorAction SilentlyContinue
Start-Sleep 1
$Username_IE.value = "grlewis"
Start-Sleep 1
$Password_IE.value = $pass
Start-Sleep 1
$Login_IE.click()
Start-Sleep 3
$Save_Button = $ie.document.IHTMLDocument3_getElementsByTagName('A') | where { $_.href -like "javascript*" } | where { $_.innerhtml -like "export*" }
Start-Sleep 1
$Save_Button.click()

#Hit "S" on the keyboard to hit the "Save" button on the download box
Start-Sleep 3
$obj = new-object -com WScript.Shell
obj.AppActivate('Internet Explorer')
$obj.SendKeys('s')

#------------------------------
#Wait for Download to complete
Sleep 10
while ($ie.Busy) { Sleep 1 }
#------------------------------
$Devices = Import-Csv "c:\users\grlewis\downloads\explorecomputers.csv"
$Excel_Clean = Remove-Item "c:\users\grlewis\downloads\explorecomputers.csv"

$Devices | Sort-Object | Export-Csv "\\hqsbisilon1\filesrv1\its\ITS Desktop Support\GRLEWIS\Profile\Powershell Logs\WebReport.Logs\WebReport_Export_Data_1.csv" -Force -NoTypeInformation
$Sourcepath = "\\hqsbisilon1\filesrv1\its\ITS Desktop Support\GRLEWIS\Profile\Powershell Logs\WebReport.Logs\WebReport_Export_Data_1.csv"
$Device_List = Get-Content -Path $SourcePath -First 2 | ConvertFrom-Csv
$SourceHeadersCleaned = $Device_List.PSObject.Properties.Name.Trim(' ') -Replace '\s',''
#This is the final result for data. 
$SourceData = Import-CSV -Path $SourcePath -Header $SourceHeadersCleaned | Select-Object -Skip 1

}

