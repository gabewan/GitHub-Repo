Import-Module MSOnline

# Connect to Azure AD
$DirSyncUsername = 'DirSync@nghs.onmicrosoft.com'
$DirSyncPassword = ConvertTo-SecureString '*' -AsPlainText -Force
$OfficeCred = New-Object System.Management.Automation.PSCredential $DirSyncUsername, $DirSyncPassword
Connect-MsolService -Credential $OfficeCred

# Get all users in the Office 365 Users group by object ID
$E3Users = Get-MsolGroupMember -GroupObjectId bd84628b-1ac5-4be8-b136-a8f7d9569109 -All
$E1Users = Get-MsolGroupMember -GroupObjectId c569e752-14a8-4594-9f8b-6d4f52031f1a -All

# Make sure we're getting enough accounts for this to be validd
If ($E3Users.Count -lt 1000 -or $E1Users.Count -lt 1000) {
  Throw "Less than 1000 Office 365 users detected."
  Exit 1
}

# Get all users not in the group
$AllUsers = Get-MsolUser -All
$NonE3Users = $AllUsers | Where-Object { $_.ObjectId -notin $E3Users.ObjectId }
$NonE1Users = $AllUsers | Where-Object { $_.ObjectId -notin $E1Users.ObjectId }
$E3AccountSkuId = 'nghs:ENTERPRISEPACK'
$E1AccountSkuId = 'nghs:STANDARDPACK'
$UsageLocation = 'US'
$E3LicenseOptions = New-MsolLicenseOptions -AccountSkuId $E3AccountSkuId
$E1LicenseOptions = New-MsolLicenseOptions -AccountSkuId $E1AccountSkuId

$E3Users | ForEach-Object {
  If ((Get-MsolUser -ObjectId $_.ObjectId).Licenses.AccountSkuId -notcontains $E3AccountSkuId) {
    Set-MsolUser -ObjectId $_.ObjectId -UsageLocation $UsageLocation
	Set-MsolUserLicense -ObjectId $_.ObjectId -AddLicenses $E3AccountSkuId -LicenseOptions $E3LicenseOptions
  }
}

$E1Users | ForEach-Object {
  If ((Get-MsolUser -ObjectId $_.ObjectId).Licenses.AccountSkuId -notcontains $E1AccountSkuId) {
    Set-MsolUser -ObjectId $_.ObjectId -UsageLocation $UsageLocation
	Set-MsolUserLicense -ObjectId $_.ObjectId -AddLicenses $E1AccountSkuId -LicenseOptions $E1LicenseOptions
  }
}

$NonE3Users | ForEach-Object {
  If ((Get-MsolUser -ObjectId $_.ObjectId).Licenses.AccountSkuId -contains $E3AccountSkuId) {
    Set-MsolUserLicense -ObjectId $_.ObjectId -RemoveLicenses $E3AccountSkuId
  }
}

$NonE1Users | ForEach-Object {
  If ((Get-MsolUser -ObjectId $_.ObjectId).Licenses.AccountSkuId -contains $E1AccountSkuId) {
    Set-MsolUserLicense -ObjectId $_.ObjectId -RemoveLicenses $E1AccountSkuId
  }
}
d