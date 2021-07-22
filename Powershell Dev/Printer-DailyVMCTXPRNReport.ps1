$Printers = Get-Printer -ComputerName VMCTXPRN -Name * | select Name,PortName,PrinterStatus
$CompObjects = New-Object System.Collections.ArrayList
$CompareObjects = New-Object System.Collections.ArrayList
$Printers_Offline = ($Printers | where {$_.PrinterStatus -eq "Offline"}).Name
$Printers_Error = ($Printers | where {$_.PrinterStatus -eq "Error"}).Name

foreach ($Printer in $Printers_Offline){
    $TempObject = "" | Select-Object 'Printer', 'Port', 'Online', 'Offline','Status'
    $Port = ($Printers | Where {$_.Name -eq "$Printer"}).PortName
    $TempObject.Printer = $Printer
    $TempObject.Port = $Port
    $TempObject.Online = "No"
    $TempObject.Offline = "Yes"
    $TempObject.Status = "Offline"
    $CompObjects.Add($TempObject) | Out-Null
    }

foreach ($Printer in $Printers_Error){
    $TempObject = "" | Select-Object 'Printer', 'Port', 'Online', 'Offline','Status'
    $Port = ($Printers | Where {$_.Name -eq "$Printer"}).PortName
    $TempObject.Printer = $Printer
    $TempObject.Port = $Port
    $TempObject.Online = "No"
    $TempObject.Offline = "Yes"
    $TempObject.Status = "Error"
    $CompObjects.Add($TempObject) | Out-Null
}

$Date = (get-date).ToString("MMddyyy")
$Date_Minus = (get-date).AddDays(-1).ToString("MMddyyy")

$CompObjects | Export-Csv "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\CompObjects_$Date.csv" -NoTypeInformation
$Daily_Printer_Check = Import-Csv -Path "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\CompObjects_$Date.csv"
$Printer_Check = Import-Csv -Path "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\CompObjects_$Date_Minus.csv"

$Grab_Offline_Printers = ($Daily_Printer_Check | where {$_.Offline -eq "yes"}).Printer
$Grab_Old_Offline_Printers = ($Printer_Check | where {$_.Offline -eq "yes"}).Printer

$Compare = Compare-Object -ReferenceObject $Grab_Old_Offline_Printers -DifferenceObject $Grab_Offline_Printers
$Compare | Export-Csv -Path "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\Compare_$Date.csv"

$Import_Compare = Import-Csv -Path "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\Compare_$Date.csv"

foreach ($Object in $Import_Compare){

$TempObject_Compare = "" | Select-Object 'Printer', 'Port', 'Online', 'Offline'

    if ($Object.SideIndicator -eq "<="){

    $TempObject_Compare.Printer = $Object.InputObject
    
    $TempObject_Compare.Port = (Get-Printer -ComputerName VMCTXPRN -Name $TempObject_Compare.Printer).PortName

        if (Test-Connection $TempObject_Compare.port -Count 1 -ErrorAction SilentlyContinue){

        $TempObject_Compare.Online = 'Yes'
        $TempObject_Compare.Offline = 'No'
        } else {

        $TempObject_Compare.Offline = 'Yes'
        $TempObject_Compare.Online = 'No'
                }

    if ($Object.SideIndicator -eq "=>"){

    $TempObject_Compare.Printer = $Object.InputObject
    
    $TempObject_Compare.Port = (Get-Printer -ComputerName VMCTXPRN -Name $TempObject_Compare.Printer).PortName

        if (Test-Connection $TempObject_Compare.port -Count 1 -ErrorAction SilentlyContinue){

        $TempObject_Compare.Online = 'Yes'
        $TempObject_Compare.Offline = 'No'
        } else {

        $TempObject_Compare.Offline = 'Yes'
        $TempObject_Compare.Online = 'No'
                }
            }
  $CompareObjects.Add($TempObject_Compare) | Out-Null
    }
}

$CompareObjects | Export-Csv "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\CompareObjects_$Date.csv" -NoTypeInformation

$Import_ComparedObjects = Import-Csv -Path "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\CompareObjects_$Date.csv" 
$Import_PreviousComparedObjects = Import-Csv -Path "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\CompareObjects_$Date_Minus.csv"

$Comparitive_Pattern_Printers = ($Import_ComparedObjects | where {$_.Offline -eq "yes"}).Printer #CurrentDate
$Comparitive_Pattern_Printers1 = ($Import_PreviousComparedObjects | where {$_.Offline -eq "yes"}).Printer #PreviousDate

if ($Comparitive_Pattern_Printers -eq $null){
Write-Host "Compartive Printers can not equal null."
}

if ($Comparitive_Pattern_Printers1 -eq $null){
Write-Host "Compartive Printers - Old - is null."
}

if ($Compartive_Pattern_Printers -ne $null -and $Comparitive_Pattern_Printers1 -ne $null){

$CheckDuplicates_Compared | Export-Csv "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\DailyComp.csv" -NoTypeInformation -Append

}

$MailTo = 'gabe.lewis@nghs.com'#$FS_Emails
$MailFrom = 'gabe.lewis@nghs.com'
$MailServer = "mail.nghs.com"
$Subject = "Inventory - Windows 10"

$Body = "<b> <font size ='14pt'> Daily Printer Report -  $Date2 </font> </b><br/>
<br/>
"

Send-MailMessage -To $MailTo -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $Body -BodyAsHtml -Attachments "\\hqsbvnxfile1\global\Grlewis\Print Application\ServerCleanup\DailyComp.csv"