
#Get All printers for VMCTXPRINT | measure-object for Total Count'
$Vmcprint = Get-Printer -ComputerName vmctxprn -name * | Sort-Object

#Get All printers for WINPRN | measure-object for Total Count'
$Winprint = Get-Printer -ComputerName winprn -name * | Sort-Object

#Creates easier tracking for Naming, faster data parameters'
$Vmcprinter = $Vmcprint.Name

#Creates easier tracking for Naming, faster data parameters'
$Winprinter = $Winprint.Name

#Creates easier tracking for Naming, faster data parameters'
$Winport = $winprint.PortName

#Creates easier tracking for Naming, faster data parameters'
$vmctxport = $vmcprint.PortName

#Creates easier tracking for Naming, faster data parameters'
$Vmcpdri = $vmcprint.DriverName

#Creates easier tracking for Naming, faster data parameters'
$Winpdri = $winprint.DriverName 

#Create Compared results. This will allow you to see which devices are still leftover from each server.  
$Cresult = Compare-Object -ReferenceObject $vmcprinter -DifferenceObject $winprinter 

#$VMC1 = @(get-printer -ComputerName vmctxprn | select name,DriverName)

#Max Count for devices. Not necessary. 
$Max = ($vmcpdri, $winpdri, $winport, $vmcport, $vmcprint, $winprint | Measure-Object -Maximum -Property Count).Maximum  

#Attach all information to Array, then export.  
$Complete = 0..$max | Select-Object @{n="VMCTXPRN Printers";e={$vmcprinter[$_]}}, @{n="VMCTXPRN Drivers";e={$vmcpdri[$_]}}, @{n="VMCTXPRN Ports";e={$vmctxport[$_]}}, @{n="WINPRN Printers";e={$winprinter[$_]}}, @{n="WINPRN Drivers";e={$winpdri[$_]}}, @{n="WINPRN Ports";e={$winport[$_]}}

#Attach all information to Array, then export. 
$Complete | export-csv -path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Documents\PrinterLogs.csv" -force

#'Grab printers from WINPRN that are not in VMCTXPRN'
$Notin_WINPRN = $cresult | where {$_.SideIndicator -eq "<="} | select InputObject

#'Grab printers from VMCTXPRN that are not in WINPRN'
$Notin_VMCTXPRN = $cresult | where {$_.SideIndicator -eq "=>"} | select InputObject


foreach ($Printer in $Notin_VMCTXPRN)

    {
        #'Next 3 lines are creating a string then replacing extra characters.'
        $TPrint = "$Printer"

        $TrimPrint = $TPrint.Trim("@", "{","}")

        $Printer_Trim = $TrimPrint.Replace("InputObject=","")

        #'Get Ports off of the foreach loop along with drivername. These are required for installs.'
        $GetPrinterPort =  (Get-printer -ComputerName WINPRN -name $Printer_Trim).PortName

        $GetPrinterDriver = (get-printer -ComputerName WINPRN -Name $Printer_Trim).DriverName

               if (Test-Connection $GetPrinter -ErrorAction SilentlyContinue){
        
                        write-host "$Printer_Trim is active"
                    
                        Add-PrinterPort -ComputerName VMCTXPRN -Name $GetPrinterPort -PrinterHostAddress $GetPrinterPort -ErrorAction SilentlyContinue
                        
                        write-host "$GetPrinterPort has been added to VMCTXPRN"

                        Add-Printer -ComputerName VMCTXPRN -Name $Printer_Trim -DriverName $GetPrinterDriver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PowerShell" 
                                
                        Write-Host "$Printer_Trim has been added to VMCTXPRN" 
                    
                   
                        
                }
        }



