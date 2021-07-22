$Vmctxprn_Printers = Get-Printer -ComputerName vmctxprn -Name * 
$Export_Objects = New-Object System.Collections.ArrayList

foreach ($Printer in $Vmctxprn_Printers.name) {
    

 $TempObject = "" | Select-Object 'PrinterName', 'DnsRecord', 'Completed'

       if ($Printer -like "*hp*"){

           $printerport = (get-printer -ComputerName vmctxprn -name $printer).PortName
 
                if (Test-Connection $printerport -Count 1 -ErrorAction SilentlyContinue){
        
                    

                $ie = New-Object -ComObject internetexplorer.application
                $ie.visible = $false
                $ie.Navigate("http://$printerport/hp/device/set_config_netIdentification.html?tab=Networking&menu=NetIdent")
                Start-Sleep -s 1
                $hp_LaserJet_400 = ($ie.Document.body.getElementsByTagName('td') | Where-Object { $_.ClassName -eq 'mastheadTitle' }).innerText


                if ($hp_LaserJet_400 -like "HP LaserJet 40*"){
                    

                $ie.document.IHTMLDocument3_getElementsByTagName("input") | Select-Object Type,Name | format-list | Out-Null -ErrorAction SilentlyContinue
                Start-Sleep -s 1
                $submithostname = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.name -eq 'Hostname'} | select value   
                Start-Sleep -s 1

                  if ($submithostname.value -like "$printer"){
        
                          $Completed = "Yes"
                      }
                  else {$Completed = "No"} 

                $TempObject.PrinterName = $Printer

                $TempObject.DnsRecord = $submithostname.value

                $TempObject.Completed = $Completed


                $Export_Objects.Add($TempObject) | Out-Null

                $ie.Quit()
                [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie) | Out-Null
                [System.GC]::Collect()
                [System.GC]::WaitForPendingFinalizers()
                }
            }
        }
    }


#$Export_Objects | Export-Csv "C:\temp\pleasedelete.csv" -Force