#$WINPRNExport = get-printer -ComputerName winprn -Name * | select name #Basic input for getting all printers on the server. 
#$VMCTXPRNExport = get-printer -ComputerName vmctxprn -Name * | select name #Basic input for getting all printers on the server. 
#$ComparePrintServers = Compare-Object  $VMCTXPRNExport $WINPRNExport  #Select $var.InputObject to trim variable
#$WinprnPortExport = Get-PrinterPort -ComputerName winprn -Name * | select name
#$vmctxprnport = Get-PrinterPort -ComputerName vmctxprn -Name * | select name 
#$ComparePrintServerPorts = Compare-Object -ReferenceObject $vmctxprnport -DifferenceObject $WinprnPortExport
$Readtrim = Get-ChildItem "\\hqsbvnxfile1\global\grlewis\Print Application\PrinterMigration\*" | select Name
$Read = get-content "\\hqsbvnxfile1\global\grlewis\Print Application\PrinterMigration\*"
$PrintArray = New-Object System.Collections.ArrayList
$Server = "winprn"

foreach($csv in $Readtrim){

    import-csv 

    import-csv "\\hqsbvnxfile1\global\grlewis\Print Application\PrinterMigration\*"

    ForEach($line in $read){

         if ($line -like '*winprn*') 
                                    {
            $PrintName = $line.Substring(89) 
            $PrintPort =  Get-Printer -ComputerName winprn -Name $PrintName -ErrorAction SilentlyContinue
            $PrintRequest = Get-Printer -ComputerName vmctxprn -Name $PrintName -ErrorAction SilentlyContinue

            $ObjectToAdd = "" | Select-Object "Printer", "Port", "Server"
	
	        #Add item under the first header.
	        $ObjectToAdd.Printer = $PrintName
	
        	#Add item under the second header.
	        $ObjectToAdd.Port = $PrintPort.PortName
	
        	#Add item under the third header.
	        $ObjectToAdd.Server = $Server
	
	        #Add this entire object to the ArrayList object you made at the beginning.
	        $PrintArray.Add($ObjectToAdd)

                            }
                         }
                     }

                     #export-csv "\\hqsbvnxfile1\global\grlewis\logs\printrun.csv"  -Append -Force'
