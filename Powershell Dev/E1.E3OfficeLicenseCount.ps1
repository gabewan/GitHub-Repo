$TenantUname = "grlewis@nghs.com"
$TenantPass = cat "\\hqsbvnxfile1\global\grlewis\AES.key" | ConvertTo-SecureString
$TenantCredentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $TenantUname, $TenantPass
$cnms = Connect-MsolService 
$365read = Get-MsolAccountSku | Select-Object AccountSkuId,ActiveUnits,ConsumedUnits | export-csv c:\users\grlewis\desktop\office365count.csv -Force
$csv = Import-csv C:\users\grlewis\desktop\office365count.csv | sort -Property "AccountSkuID"
$e3 = $csv[0] #E3 Enterprise Pack #2050
$e1 = $csv[9] #E1 Standard #6670
$e31 = $e3.ActiveUnits
$e12 = $e1.ActiveUnits
$e13 = $e1.ConsumedUnits
$e32 = $e3.ConsumedUnits
$MailTo2 = "Wesley Ash <wesley.ash@nghs.com>"
$MailTo3 = "Steve Brummer <steve.brummer@nghs.com>"
$MailTo4 = "Gabe Lewis <gabe.lewis@nghs.com>"
$MailFrom = "Office 365 License Information<gabe.lewis@nghs.com>"
$MailServer = "mail.nghs.com"
$Subject = "Office 365 License Counts"


if ($e3.activeunits -le $e3.ConsumedUnits){

   $MsgBody = "E3 Licenses are under par. Current active licenses: $e31 Current Used Licenses: $e32"
     #Send-MailMessage -To $MailTo2 -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $MsgBody
      #Send-MailMessage -To $MailTo3 -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $MsgBody
        Send-MailMessage -To $MailTo4 -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $MsgBody
    }
if ($e1.ActiveUnits -le $e1.ConsumedUnits)
    {
     $MsgBody2 = "E1 Licenses are under par. Current active licenses: $e12 "
     #Send-MailMessage -To $MailTo2 -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $MsgBody2
     #Send-MailMessage -To $MailTo3 -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $MsgBody2
       Send-MailMessage -To $MailTo4 -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $MsgBody2
    }

    exit


