         $Vmctxprn_Printers = $Vmctxprn_Printers = Get-Printer -ComputerName vmctxprn -Name * | Sort-Object name | Where {$_.DriverName -like "*HP*"}
         $Export_Objects = New-Object System.Collections.ArrayList

         foreach ($Printer in $Vmctxprn_Printers.name) {

            

         $TempObject = "" | Select-Object 'PrinterName', 'DnsRecord', 'Completed','SecurityEnabled','PrinterPort'

         $printerport = ($vmctxprn_printers | Where {$_.name -like $printer}).PortName

         if (Test-Connection $printerport -Count 1 -ErrorAction SilentlyContinue){


            $PrinterName = $Printer

            Write-Host "$PrinterName"

            $PrinterPort_Raw = $printerport

            $Request = Invoke-WebRequest -Uri "http://$PrinterPort_Raw/info_config_network.html?tab=Home&menu=NetConfig"
            
            $Raw_CheckSecurity = ($Request.AllElements | Where-Object {$_.InnerHtml -like "*:*"} | Where-Object {$_.innerHTML -like '<TD Class=labelFont>Administrator Password:*'}).innerText

            $Raw_Hostname = ($Request.AllElements | Where-Object {$_.InnerHtml -like "*:*"} | Where-Object {$_.innerHTML -like '<TD class=labelFont>Host Name: </TD>*'}).outerText

            $Hostname_T = "$Raw_Hostname"

            $Hostname_F = $Hostname_T.Replace("Host Name: ","")

            $Hostname = $Hostname_F.Trim()

            $CheckSecurity_T = "$Raw_CheckSecurity"

            $CheckSecurity = $CheckSecurity_T.Replace("Administrator Password: ","")

            if ($Hostname -eq $PrinterName){

            $Completed = "Yes"

            } else {$Completed = "No"}


            #Building Array - LN: 43 - 55
      
  $TempObject.PrinterName = $Printer

  $TempObject.DnsRecord = $Hostname

  $TempObject.Completed = $Completed

  $TempObject.SecurityEnabled = $CheckSecurity 
            
  $TempObject.PrinterPort = $PrinterPort_Raw            

   $Export_Objects.Add($TempObject) | Out-Null
            
                    }
                }

            
        
     #$Export_Objects | Export-Csv -Path 'C:\temp\PrinterDns.Csv' -Force -NoTypeInformation