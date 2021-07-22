$Export = Get-ADGroupMember "Office 365 Users" |  select SamAccountName #| export-csv "C:\temp\2.20.test.delete.csv" #Export all members of the Office 365 Users group in Active Directory
#$Import = import-csv "C:\temp\2.20.test.delete.csv" #Import the Offce 365 users. Helps with foreach clause
$TenantUname = "grlewis@nghs.com"
$TenantPass = cat "\\hqsbvnxfile1\global\grlewis\AES.key" | ConvertTo-SecureString
$TenantCredentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $TenantUname, $TenantPass
$CNMS = Connect-MsolService -Credential $TenantCredentials


foreach($name in $export) 
{
$loc1 = "$name" #loc trims the array to make it easier to call in $entp
$loc2 = $loc1.Trim("@", "{","}")
$loc3 = $loc2.Replace("SamAccountName=","")
$gmo = get-msoluser -UserPrincipalName "$loc3@nghs.com"

  $Entp = (Get-MsolUser -UserPrincipalName "$loc3@nghs.com").Licenses | select accountskuid 

      if ($Entp.AccountSkuId -eq "nghs:STANDARDPACK")
        {
         #Set-MsolUserLicense -UserPrincipalName "$loc3" -RemoveLicenses "nghs:STANDARDPACK" -AddLicenses "nghs:ENTERPRISEPACK" 
         write-host "$loc3 is not active for E3"
        }

}


#$UserCredential = Get-Credential
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import-PSSession $Session#

#get-mailbox | get-mailboxstatistics | ft displayname, totalitemsize 