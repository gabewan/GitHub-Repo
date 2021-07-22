#$WINPRNExport = get-printer -ComputerName winprn -Name * | select name,PortName #Basic input for getting all printers on the server. 
#$ComparePrintServers = Compare-Object  $VMCTXPRNExport $WINPRNExport  #Select $var.InputObject to trim variable
#$ComparePrintServerPorts = Compare-Object -ReferenceObject $vmctxprnport -DifferenceObject $WinprnPortExport
#$VMCTXPRNExport = get-printer -ComputerName vmctxprn -Name * | select name,PortName #Basic input for getting all printers on the server. 
#$Readtrim = Get-ChildItem "\\hqsbvnxfile1\global\grlewis\Print Application\PrinterMigration\*" | select Name
#$Read = get-content "\\hqsbvnxfile1\global\grlewis\Print Application\PrinterMigration\*"
#$PrintArray = New-Object System.Collections.ArrayList
#$Server = "winprn



function Get-PrinterPorts(){
[CmdletBinding()]
param ($Server)

#Gather Printer Ports from VMCTXPRN/WINPRN

    if ($server -eq 'Winprn') {
        Get-PrinterPort -ComputerName winprn -Name * 
        }

    if ($server -eq 'vmctxprn') {
        Get-PrinterPort -ComputerName VMCTXPRN -Name * 
        }
}

function Clean-PrinterPorts(){
[CmdletBinding()]
param ($Server)

#Gather added Ports. Will need to delete these records.

    if ($server -eq 'winprn') {
        $WinprnPortExport | Where-Object {$_.name -like '*_1*'}
        }

    if ($server -eq 'vmctxprn') {
        $Vmctxprnport | Where-Object {$_.name -like '*_1*'}
        }
}







