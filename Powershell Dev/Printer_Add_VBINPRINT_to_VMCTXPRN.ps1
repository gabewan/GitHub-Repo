$VBIN_Printers = Get-Printer -ComputerName Vbinprint -name * 
$VMCTX_Printers = Get-Printer -ComputerName Vmctxprn -name * | select name 
$VBIN_Ports = Get-PrinterPort -ComputerName Vbinprint -Name * 
$VMCTX_Ports = Get-PrinterPort -ComputerName Vmctxprn -Name * 
$Comparitive_Printers = Compare-Object $VBIN_Printers.name -DifferenceObject $VMCTX_Printers.name
$Comparetive_Ports = Compare-Object $VBIN_Ports.Name  -DifferenceObject $VMCTX_Ports.Name
$ExportPrint_Inventory = New-Object System.Collections.ArrayList
$ExportPort_Inventory = New-Object System.Collections.ArrayList
$ExportNew_Inventory = New-Object System.Collections.ArrayList
$PortRegEx = '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
$PrinterRegEx = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'
$Driver_Xerox = "Xerox GPD PCL6 V3.9.520.6.0"
$Driver_HP = "HP Universal Printing PCL 5"
$GS = 'Added by GRLEWIS _ PS'

foreach ($printer in $Comparitive_Printers){

$Array_Inventory = "" | Select-Object 'Printer','Port','Server','Driver'

    if ($printer.SideIndicator -eq '<='){
     $Array_Inventory.Printer = $Printer.InputObject
     $Portname = Get-Printer -ComputerName VBINPRINT -Name $printer.InputObject | select PortName
     $Array_Inventory.Port = $Portname.PortName
     $Array_Inventory.Server = "VbinPrint"    
     $Array_Inventory.Driver = (Get-Printer -ComputerName vbinprint -name $printer.InputObject).DriverName
     $ExportPrint_Inventory.Add($Array_Inventory) | Out-Null
     }
    }


foreach ($New_Printer in $ExportPrint_Inventory){

 $NewArray_Inventory = "" | Select-Object 'Printer','Port','Server','Completed'

        if ($New_Printer.Driver -like "*HP*"){

            $New_PrinterPort = ($ExportPrint_Inventory | where {$_.Printer -eq $New_Printer.printer}).Port
            $Printer_Update =  $New_Printer.Printer
            $Printer_Case = "$Printer_Update"
            $Printer_New = $Printer_Case.ToUpper()
            $NewArray_Inventory.Printer = $Printer_New 
            $NewArray_Inventory.Port = $New_PrinterPort
            $NewArray_Inventory.Server = "VMCTXPRN"

        Add-Printer -ComputerName vmctxprn -Name $Printer_New -PortName $New_PrinterPort -DriverName "$Driver_HP" -Comment "$GS" -ShareName $Printer_New -Shared
        if (((Get-Printer -ComputerName VMCTXPRN -name $Printer_New)).Name -eq $Printer_New){
            $NewArray_Inventory.Completed = "No"
            } 
        

        if ($New_Printer.Driver -like "*Xerox*"){
        $New_PrinterPort = ($ExportPrint_Inventory | where {$_.Printer -eq $New_Printer.printer}).Port
        $Printer_Update =  $New_Printer.Printer
        $Printer_Case = "$Printer_Update"
        $Printer_New = $Printer_Case.ToUpper()
        $NewArray_Inventory.Printer = $Printer_New 
        $NewArray_Inventory.Port = $New_PrinterPort
        $NewArray_Inventory.Server = "VMCTXPRN"
        Add-Printer -ComputerName vmctxprn -Name $Printer_New -PortName $New_PrinterPort -DriverName "$Driver_Xerox" -Comment "$GS" -ShareName $Printer_New -Shared 
        if (((Get-Printer -ComputerName VMCTXPRN -name $Printer_New)).Name -eq $Printer_New){
            $NewArray_Inventory.Completed = "Yes"
            } else {$NewArray_Inventory.Completed = "No"}
        }

    $ExportNew_Inventory.Add($NewArray_Inventory) | Out-Null 

    }


 