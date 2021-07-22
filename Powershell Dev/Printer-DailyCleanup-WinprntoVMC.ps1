$vmcprint = Get-Printer -ComputerName winprn -name * | Sort-Object
$winprint = Get-Printer -ComputerName vmctxprn -name * | Sort-Object
$vmcprinter = $Vmcprint.Name
$winprinter = $Winprint.Name
$winport = $winprint.PortName
$vmctxport = $vmcprint.PortName
$vmcpdri = $vmcprint.DriverName
$winpdri = $winprint.DriverName 
$Cresult = Compare-Object -ReferenceObject $vmcprinter -DifferenceObject $winprinter  #| Out-GridView
$VMC1 = @(get-printer -ComputerName vmctxprn | select name,DriverName)
$Max = ($vmcpdri, $winpdri, $winport, $vmcport, $vmcprint, $winprint | Measure-Object -Maximum -Property Count).Maximum    
$Complete = 0..$max | Select-Object @{n="VMCTXPRN Printers";e={$vmcprinter[$_]}}, @{n="VMCTXPRN Drivers";e={$vmcpdri[$_]}}, @{n="VMCTXPRN Ports";e={$vmctxport[$_]}}, @{n="WINPRN Printers";e={$winprinter[$_]}}, @{n="WINPRN Drivers";e={$winpdri[$_]}}, @{n="WINPRN Ports";e={$winport[$_]}}
$Complete | export-csv -path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Documents\PrinterLogs.csv" -force


#'Grab printers from WINPRN that are not in VMCTXPRN'
$Notin_VMCTXPRN = $cresult | where {$_.SideIndicator -eq "<="} | select InputObject

#'Grab printers from VMCTXPRN that are not in WINPRN'
$Notin_WINPRN = $cresult | where {$_.SideIndicator -eq "=>"} | select InputObject


foreach ($Printer in $Notin_VMCTXPRN)

    {
        $TPrint = "$Printer"

        $TrimPrint = $TPrint.Trim("@", "{","}")

        $Printer_Trim = $TrimPrint.Replace("InputObject=","")

        $GetPrinterPort =  (Get-printer -ComputerName WINPRN -name $Printer_Trim).PortName

        $GetPrinterDriver = (get-printer -ComputerName WINPRN -Name $Printer_Trim).DriverName

               if (Test-Connection $GetPrinterport -ErrorAction SilentlyContinue){

                    #write-host "$Printer_Trim is active"
                    
                    #Add-PrinterPort -ComputerName VMCTXPRN -Name $GetPrinterPort -PrinterHostAddress $GetPrinterPort 

                    #write-host "$GetPrinterPort has been added to VMCTXPRN"

               if ($GetPrinterDriver -eq "Xerox WorkCentre 7855 PCL6"){
                
                   $xrdriver =  "Xerox GPD PCL6 V3.9.520.6.0"

                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $xrdriver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                
               if ($GetPrinterDriver -eq "HP Color LaserJet Pro M252 PCL 6"){
                
                   $HP4driver =  "HP Universal Printing PCL 5"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP4driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
               
               if ($GetPrinterDriver -eq "HP ColorLaserJet MFP M278-M281 PCL 6 (V3)"){
                
                   $HP5driver =  "HP Universal Printing PCL 5"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP5driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                
                   if ($GetPrinterDriver -eq "HP LaserJet 200 color M251 PCL 6*"){
                
                   $HP6driver =  "HP Universal Printing PCL 5"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP6driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                   if ($GetPrinterDriver -eq "HP LaserJet 400 M401 PCL 6"){
                
                   $HP7driver =  "HP Universal Printing PCL 5"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP7driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                   if ($GetPrinterDriver -eq "HP LaserJet 400 M401 PCL6 Class Driver"){
                
                   $HP8driver =  "HP Universal Printing PCL 5"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP8driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                   if ($GetPrinterDriver -eq "HP LaserJet Pro M402-M403 PCL 6"){
                
                   $HP9driver =  "HP Universal Printing PCL 5"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP9driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                   if ($GetPrinterDriver -eq "HP Universal Printing PCL 5"){
                
                   $HP10driver =  "HP Universal Printing PCL 5"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP10driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                   if ($GetPrinterDriver -eq "Xerox Global Print Driver PCL6"){
                
                   $HP11driver =  "Xerox GPD PCL6 V3.9.520.6.0"
                   Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $HP11driver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 

                }
                Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $GetPrinterDriver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 
                                
                Write-Host "$Printer_Trim has been added to VMCTXPRN"         
               
             }
        }



