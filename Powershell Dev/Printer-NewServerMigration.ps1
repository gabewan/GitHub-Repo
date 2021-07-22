
#Get All printers for VMCTXPRINT | measure-object for Total Count'
$VMCTXPRN = Get-Printer -ComputerName VMCTXPRN -name * | Sort-Object

#Creates easier tracking for Naming, faster data parameters'
$VMCTXPRN_Printers = $VMCTXPRN.Name

#Creates easier tracking for Naming, faster data parameters'
$VMCTXPRN_Ports = $VMCTXPRN.PortName

#Creates easier tracking for Naming, faster data parameters'
$VMCTXPRN_Drivers = $VMCTXPRN.DriverName

#Get All printers for WINPRN | measure-object for Total Count'
$Newserver = Get-Printer -ComputerName NewServer_Name -name * | Sort-Object

#Creates easier tracking for Naming, faster data parameters'
$NewServer_Printers = $NewServer.Name

#Creates easier tracking for Naming, faster data parameters'
$NewServer_Ports = $NewServer.PortName

#Creates easier tracking for Naming, faster data parameters'
$NewServer_Drivers = $winprint.DriverName 

#Create Compared results. This will allow you to see which devices are still leftover from each server.  
$Cresult = Compare-Object -ReferenceObject $VMCTXPRN_Printers -DifferenceObject $NewServer_Printers

#Attach all information to Array, then export.  
$Complete = 0..$max | Select-Object 
@{n="VMCTXPRN Printers";e={$VMCTXPRN_Printers[$_]}}, 
@{n="VMCTXPRN Drivers";e={$VMCTXPRN_Drivers[$_]}}, 
@{n="VMCTXPRN Ports";e={$VMCTXPRN_Ports[$_]}}, 
@{n="NewServer Printers";e={$NewServer_Printers[$_]}}, 
@{n="NewServer Drivers";e={$NewServer_Drivers[$_]}}, 
@{n="NewServer Ports";e={$NewServer_Ports[$_]}}

#Attach all information to Array, then export. 
$Complete | Export-Csv -Path "C:\" -Force

#'Grab printers from WINPRN that are not in VMCTXPRN'
$Notin_NewServer = $Cresult | where {$_.SideIndicator -eq "<="} | select InputObject 

#'Grab printers from VMCTXPRN that are not in WINPRN'
$Notin_VMCTXPRN = $Cresult | where {$_.SideIndicator -eq "=>"} | select InputObject

#Need to add drivers to New Print Server. 
$VMCTXPRN_DriverStore = Get-PrinterDriver -ComputerName VMCTXPRN  
$Driver_path = "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\"

foreach ($Driver in $VMCTXPRN_DriverStore.Name)
    
    {

    Switch ($Driver)

        {

        #"Dell 2150cn Color Printer PCL6" {
            #Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\prndlclf.inf_amd64_4dae85065a0b5079\*" -Destination "C:\Windows\System32\Driverstore\FileRepository\Dell 2150cn Color Printer PCL6" -Force
            #Invoke-Command -ComputerName NewServer {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\hpcu130t.inf"}
            #Add-PrinterDriver -ComputerName NewServer -Name "Dell 2150cn Color Printer PCL6"
            #} 

            
        "Dell 2330dn Laser Printer" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\dkachl40.inf_amd64_384f44ebb4c816aa\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\dkachl40.inf_amd64_384f44ebb4c816aa" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\dkachl40.inf_x86_384f44ebb4c816aa\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\dkachl40.inf_x86_384f44ebb4c816aa" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\dkachl40.inf_amd64_384f44ebb4c816aa\dkachl40.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\dkachl40.inf_x86_384f44ebb4c816aa\dkachl40.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Dell 2330dn Laser Printer" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\dkachl40.inf_amd64_384f44ebb4c816aa\dkachl40.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Dell 2330dn Laser Printer" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\dkachl40.inf_x86_384f44ebb4c816aa\dkachl40.inf"
            }

         "Dell 3130cn PCL6" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\prndlclf.inf_amd64_4dae85065a0b5079\*" -Destination "\\$NewServer_Name\c$\windows\system32\driverstore\FileRepository\prndlclf.inf_amd64_4dae85065a0b5079" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\windows\system32\driverstore\FileRepository\prndlclf.inf_amd64_4dae85065a0b5079\prndlclf.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Dell 3130cn PCL6" -InfPath "\\$NewServer_Name\c$\windows\system32\driverstore\FileRepository\prndlclf.inf_amd64_4dae85065a0b5079\prndlclf.inf"
            }

         "Dell 3130cn Color Laser PS" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\dlpsbmei.inf_amd64_48acb9a61d4bb117\*" -Destination "\\$NewServer_Name\c$\windows\system32\driverstore\FileRepository\dlpsbmei.inf_amd64_48acb9a61d4bb117" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\dlpsbmei.inf_x86_cca7b682bff9b449\*" -Destination "\\$NewServer_Name\c$\windows\system32\driverstore\FileRepository\prndlclf.inf_x86_cca7b682bff9b449" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\windows\system32\driverstore\FileRepository\dlpsbmei.inf_amd64_48acb9a61d4bb117\dlpsbmei.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\windows\system32\driverstore\FileRepository\prndlclf.inf_x86_cca7b682bff9b449\dlpsbmei.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Dell 3130cn Color Laser PS" -InfPath "\\$NewServer_Name\c$\windows\system32\driverstore\FileRepository\dlpsbmei.inf_amd64_48acb9a61d4bb117\dlpsbmei.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Dell 3130cn Color Laser PS" -InfPath "\\$NewServer_Name\c$\windows\system32\driverstore\FileRepository\prndlclf.inf_x86_cca7b682bff9b449\dlpsbmei.inf"
            }

            
        "HP Laserjet 200 color M251 PCL 6" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\hpcm251u.inf_amd64_e21a92c8ba792767\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcm251u.inf_amd64_e21a92c8ba792767" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\hpcm251c.inf_x86_30ea4429119b5b89\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcm251c.inf_x86_30ea4429119b5b89" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\hpcm251u.inf_amd64_e21a92c8ba792767\hpcm251u.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\hpcm251u.inf_x86_30ea4429119b5b89\hpcm251c.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "HP Laserjet 200 color M251 PCL 6" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcm251u.inf_amd64_e21a92c8ba792767\hpcm251u.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "HP Laserjet 200 color M251 PCL 6" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcm251c.inf_x86_30ea4429119b5b89\hpcm251c.inf"
            }

        "HP Universal Printing PCL 5" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\hpcu130t.inf_amd64_df89f38067b4c9a\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcu130t.inf_amd64_df89f38067b4c9a" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\hpcu130b.inf_x86_35c2bb288417c75f\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcu130b.inf_x86_35c2bb288417c75f" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\hpcu130t.inf_amd64_df89f38067b4c9a\hpcu130t.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\hpcu130b.inf_x86_35c2bb288417c75f\hpcu130b.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "HP Universal Printing PCL 5" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcu130t.inf_amd64_df89f38067b4c9a\hpcu130t.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "HP Universal Printing PCL 5" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\hpcu130b.inf_x86_35c2bb288417c75f\hpcu130b.inf"
            }

        "KX DRIVER for Universal Printing" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\oemsetup.inf_amd64_333aabeeb55fe597\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\oemsetup.inf_amd64_333aabeeb55fe597" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\oemsetup.inf_x86_5f5b1bbdd47adce9\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\oemsetup.inf_x86_5f5b1bbdd47adce9" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\oemsetup.inf_amd64_333aabeeb55fe597\oemsetup.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\oemsetup.inf_x86_5f5b1bbdd47adce9\oemsetup.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "KX DRIVER for Universal Printing" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\oemsetup.inf_amd64_333aabeeb55fe597\oemsetup.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "KX DRIVER for Universal Printing" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\oemsetup.inf_x86_5f5b1bbdd47adce9\oemsetup.inf"
            }

        "Lexmark Universal v2" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\lmud1040.inf_amd64_a3a4a06766520041\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1040.inf_amd64_a3a4a06766520041" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\lmud1o40.inf_x86_3d9c1d9f352b35bd\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1o40.inf_x86_3d9c1d9f352b35bd" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\lmud1040.inf_amd64_a3a4a06766520041\lmud1040.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\lmud1o40.inf_x86_3d9c1d9f352b35bd\lmud1040.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Lexmark Universal v2" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1040.inf_amd64_a3a4a06766520041\lmud1040.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Lexmark Universal v2" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1o40.inf_x86_3d9c1d9f352b35bd\lmud1040.inf"
            }

        "Lexmark Universal v2 PS3" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\lmud1n40.inf_amd64_0ae5284873d3ba9c\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1n40.inf_amd64_0ae5284873d3ba9c" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\lmud1n40.inf_x86_0ae5284873d3ba9c\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1n40.inf_amd64_0ae5284873d3ba9c" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\lmud1n40.inf_amd64_0ae5284873d3ba9c\lmud1n40.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\lmud1n40.inf_x86_0ae5284873d3ba9c\lmud1n40.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Lexmark Universal v2 PS3" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1n40.inf_amd64_0ae5284873d3ba9c\lmud1n40.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Lexmark Universal v2 PS3" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\lmud1n40.inf_amd64_0ae5284873d3ba9c\lmud1n40.inf"
            }
            
        #"SHARP UD2 PCL6" {
            #Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\prndlclf.inf_amd64_4dae85065a0b5079\*" -Destination "C:\Windows\System32\Driverstore\FileRepository\SHARP UD2 PCL6" -Force
            #Invoke-Command -ComputerName NewServer {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\hpcu130t.inf"}
            #Add-PrinterDriver -ComputerName NewServer -Name "SHARP UD2 PCL6"
            #}

         "Xerox AltaLink C8055 PCL6" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\x3askyx.inf_amd64_bc17fb29001dffc\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x3askyx.inf_amd64_bc17fb29001dffc" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\x3askyx.inf_amd64_bc17fb29001dffc\x3askyx.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Xerox AltaLink C8055 PCL6" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x3askyx.inf_amd64_bc17fb29001dffc\x3askyx.inf"
            }

         "Xerox Global Print Driver PCl6" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\x2univx.inf_amd64_5ca010674865827d\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_amd64_5ca010674865827d" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\x2univx.inf_x86_d3c12cf31488484\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_x86_d3c12cf31488484" -Force
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\x2univx.inf_amd64_5ca010674865827d\x2univx.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\x2univx.inf_x86_d3c12cf31488484\x2univx.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Xerox Global Print Driver PCl6" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_amd64_5ca010674865827d\x2univx.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "Xerox Global Print Driver PCl6" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_x86_d3c12cf31488484\x2univx.inf"
            }

        #"Xerox Global Print Driver PS" {
            #Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\x2univx.inf_amd64_f2c085839a479d09\*" -Destination "C:\Windows\System32\Driverstore\FileRepository\Xerox GPD PCL6 V3.9.520.6.0" -Force
            #Invoke-Command -ComputerName NewServer {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\x2univx.inf"}
            #Add-PrinterDriver -ComputerName NewServer -Name "HP Universal Printing PCL 5"
            #}

         "Xerox GPD PCL6 V3.9.520.6.0" {
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\x2univx.inf_amd64_f2c085839a479d09\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_amd64_f2c085839a479d09" -Force -Recurse
            Copy-Item -Path "\\vmctxprn\c$\windows\system32\DriverStore\FileRepository\x2univx.inf_x86_f9cb35c266fb1348\*" -Destination "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_x86_f9cb35c266fb1348" -Force -Recurse
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\x2univx.inf_amd64_f2c085839a479d09\x2univx.inf"}
            Invoke-Command -ComputerName $NewServer_Name {pnputil.exe -a "C:\Windows\System32\Driverstore\FileRepository\x2univx.inf_x86_f9cb35c266fb1348\x2univx.inf"}
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "HP Universal Printing PCL 5" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_amd64_f2c085839a479d09\x2univx.inf"
            Add-PrinterDriver -ComputerName $NewServer_Name -Name "HP Universal Printing PCL 5" -InfPath "\\$NewServer_Name\c$\Windows\System32\Driverstore\FileRepository\x2univx.inf_x86_f9cb35c266fb1348\x2univx.inf"
            }

         }
      }       
          
foreach ($Printer in $Notin_NewServer)

     {

        #'Next 3 lines are creating a string then replacing extra characters.'
        $TPrint = "$Printer"

        $TrimPrint = $TPrint.Trim("@", "{","}")

        $Printer_Trim = $TrimPrint.Replace("InputObject=","")

        #'Get Ports off of the foreach loop along with drivername. These are required for installs.'
        $GetPrinterPort =  (get-printer -ComputerName VMCTXPRN -Name $Printer_Trim).PortName

        $GetPrinterDriver = (get-printer -ComputerName VMCTXPRN -Name $Printer_Trim).DriverName


            if (Test-Connection $GetPrinterPort -ErrorAction SilentlyContinue)
            
            {

                $NewPrinterPort = (Get-Printer -ComputerName VMCTXPRN -Name $Printer_Trim).Name
  
                Add-PrinterPort -ComputerName NewServer -Name $NewPrinterPort -PrinterHostAddress $NewPrinterPort -ErrorAction SilentlyContinue

                Add-Printer -ComputerName NewServer -Name $Printer_Trim -DriverName $GetPrinterDriver -PortName $GetPrinterPort -Comment "Created by GRLEWIS - PS" 
                                
                $Validate = Get-Printer -ComputerName NewServer -Name $Printer_Trim

                if ($Printer_Trim -eq $Validate.Name)
                
                    {

                    $Validate | Export-Csv "C:\Temp\PrintersAdded.Csv" -Append -Force
                 
                    }
                   
             }

    }
