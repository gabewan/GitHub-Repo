$OldPrinters = Get-Printer -ComputerName WINPRN | Select Name,Comment,DriverName,Location,PortName
$ExporTIMP = $OldPrinters | Sort-Object | Export-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\temp\printers_winprn.csv" -Force -NoTypeInformation 
$SubInfo = Import-Csv '\\hqsbvnxfile1\its\data\DMJ\PS\PSData\ipam_networks_with_netmask.csv'
$Printers = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\temp\printers_winprn.csv"
$PrinterInfo = New-Object System.Collections.ArrayList

$Current = 0
$Total = $Printers.Count
:Printers foreach($Printer in $Printers){
    $Current++
    Write-Progress -Status "$Current / $Total" -Activity 'Getting printer subnet'
    :setip switch -Regex ($($Printer.PortName)){
        '^\d+\.\d+\.\d+\.\d+$' {
            [IPAddress]$IPAddress = $Printer.PortName
            continue setip
        }

        '^\d+\.\d+\.\d+\.\d+_\d+$' {
            [IPAddress]$IPAddress = $Printer.PortName.substring(0,$($Printer.PortName).IndexOf('_'))
            continue setip
        }

        default {
            $TmpResolve = Resolve-DnsName $Printer.PortName -ErrorAction SilentlyContinue
            if($TmpResolve){
                [IPAddress]$IPAddress = $TmpResolve.IPAddress
            } else {
                [void]$PrinterInfo.Add([pscustomobject]@{
                    Name = $Printer.Name
                    Comment = $Printer.Comment
                    DriverName = $Printer.DriverName
                    Location = $Printer.Location
                    PortName = $Printer.PortName
                    Subnet = 'Unknown PortName'
                    SubLocation = 'Unknown'
                })
                continue Printers
            }
        }
    }
    $TmpPrinterInfo = [pscustomobject]@{
        Name = $Printer.Name
        Comment = $Printer.Comment
        DriverName = $Printer.DriverName
        Location = $Printer.Location
        PortName = $Printer.PortName
        Subnet = $Null
        Sublocation = $null
    }
    :FindSub foreach($SubNetInfo in $SubInfo){
        [IPAddress]$Subnet = $SubNetInfo.Network
        [IPAddress]$Mask = $SubNetInfo.netmask
        $Location = $SubNetInfo.Location
        if($Subnet.Address -eq ($IPAddress.Address -band $Mask.Address)){
            $TmpPrinterInfo.Subnet = $Subnetinfo.network
            $TmpPrinterInfo.SubLocation = $Location
            break FindSub
        } else {
            $TmpPrinterInfo.Subnet = 'Unknown'
            $TmpPrinterInfo.SubLocation = 'Unknown'
            continue FindSub
        }
    }
    [void]$PrinterINfo.Add($TmpPrinterInfo)
}

$PrinterInfo | Export-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\printers_winprn.csv" -Force -NoTypeInformation

$GetDate = Get-Date
$MailTo = 'gabe.lewis@nghs.com'#$FS_Emails
$MailFrom = "gabe.lewis@nghs.com (POWERSHELL REPORTING)"
$MailServer = "mail.nghs.com"
$Subject = "Hourly_Printer_Export_WINPRN - RAN:$GetDate PSREPORT"
$Attachment = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\printers_winprn.csv"
$Body = "<b> <font size ='14pt'> VMCTXPRN Printer Pull - RAN  $Date2 </font> </b><br/>
<br/>
"
Send-MailMessage -To $MailTo -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $Body -BodyAsHtml -Attachments $Attachment
