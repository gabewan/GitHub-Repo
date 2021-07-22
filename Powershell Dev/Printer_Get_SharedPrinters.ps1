$Vbin = 'VMCTXPRN'
$Printer_List = (Get-Printer -ComputerName $Vbin).Name
foreach ($Printer in $Printer_List){
    
  $Check_Shared = (Get-Printer -ComputerName $Vbin -Name $Printer).Shared
    
    if ($Check_Shared -ne 'True'){
        
        $Printers = $Printer
            
            write-host $Printers
  }
}