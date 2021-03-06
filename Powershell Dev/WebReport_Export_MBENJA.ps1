$pass = Read-Host Enter LDAP Pass
$ie = New-Object -ComObject internetexplorer.application
Start-Sleep 1
$ie.visible = $false
Start-Sleep 1
#The URL here needs to be the filters applied already. So with mine, it applies All Devices based on Name and ID
$ie.Navigate(httpsvmwsbigfix01.nghs.comwebreportspage=ExploreComputers#collapseState=4e697d7d6da84550505cf4529556ec9692c5cfde&reportInfo=&filterManager=8fb7d4c16a605c80d239c3fd388460f896e2c51b&chartSection=&wr_computerTable=d8c141b5f5f7fae66a4986151fc728fa0523e7d6)
#$ie.Navigate(httpsvmwsbigfix01.nghs.comwebreportspage=ExploreComputers#collapseState=4e697d7d6da84550505cf4529556ec9692c5cfde&reportInfo=&filterManager=&chartSection=&wr_computerTable=e96171b9b5828dd73ace6e7d243992ec8ce85889)
Start-Sleep 1
$Username_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input')  where {$_.name -eq username} -ErrorAction SilentlyContinue
Start-Sleep 1
$Login_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input')  Where-Object {$_.type -eq 'submit'}
Start-Sleep 1
$Password_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input')  Where-Object {$_.type -eq 'Password'} -ErrorAction SilentlyContinue
Start-Sleep 1
#$Site = httpsvmwsbigfix01.nghs.comwebreportspage=ExploreComputers#collapseState=4e697d7d6da84550505cf4529556ec9692c5cfde&reportInfo=&filterManager=20b7971d12ad64ed5d75b8551417bca728c3f093&chartSection=&wr_computerTable=701fafa4a2e17e42d8a02027cb10e6357db80f36
$Username_IE.value = grlewis
Start-Sleep 1
$Password_IE.value = $pass
Start-Sleep 1
$Login_IE.click()
Start-Sleep 3
$Save_Button = $ie.document.IHTMLDocument3_getElementsByTagName('A')  where {$_.href -like javascript}  where {$_.innerhtml -like export}
Start-Sleep 1
$Save_Button.click()

#Hit S on the keyboard to hit the Save button on the download box
Start-Sleep 3
$obj = new-object -com WScript.Shell
$obj.AppActivate('Internet Explorer')
$obj.SendKeys('s')

#------------------------------
#Wait for Download to complete
Sleep 10
while($ie.Busy){Sleep 1} 
#------------------------------

$Devices = Import-Csv cusersgrlewisdownloadsexplorecomputers.csv
$Excel_Clean = Remove-Item cusersgrlewisdownloadsexplorecomputers.csv

$Devices  Sort-Object  Export-Csv 'hqsbisilon1filesrv1itsITS Desktop SupportGRLEWISProfilePowershell LogsWebReport.LogsWebReport_Export_Global.csv' -Force -NoTypeInformation