$Vmctxprn_Printers = Get-Printer -ComputerName vmctxprn -Name * 


foreach ($Printer in $Vmctxprn_Printers.name) {
    
       if ($Printer -like "*hp*"){


           $printerport = (get-printer -ComputerName vmctxprn -name $printer).PortName

           

            if (Test-Connection $printerport -ErrorAction SilentlyContinue){

                $hp_LaserJet_400 = ($ie.Document.body.getElementsByTagName('td') | Where-Object { $_.ClassName -eq 'mastheadTitle' }).innerText

                
                if ($hp_LaserJet_400 -like "*HP LaserJet 400*"){
                 write-host "$printerport","$printer"

$ie = New-Object -ComObject internetexplorer.application

$ie.visible = $false

$ie.Navigate("http://$printerport/hp/device/set_config_netIdentification.html?tab=Networking&menu=NetIdent")
Start-Sleep -s 1
$ie.document.IHTMLDocument3_getElementsByTagName("input") | Select-Object Type,Name | format-list | Out-Null -ErrorAction SilentlyContinue
Start-Sleep -s 1
$submithostname = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.name -eq 'Hostname'}     
Start-Sleep -s 2
$submithostname.value = "$Printer"
Start-Sleep -s 2
$submitButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit' -and $_.name -eq 'apply_button'}
Start-Sleep -s 2
$submitButtonclick = $submitButton.click()

#Store the information from this run into the array  
  $Output = New-Object -TypeName PSObject -Property @{
    Printer = $Printer
    Port  = $printerport
    Result = "Complete"
  } | Select-Object Printer,Port,Result
}
}

#Output the array to the CSV File
$Output | Export-Csv C:\GPoutput.csv -Append -Force




Start-Job -ScriptBlock {
                Start-Sleep 4
                Add-Type -AssemblyName Microsoft.VisualBasic, System.Windows.Forms
                [Microsoft.VisualBasic.Interaction]::AppActivate('Message from webpage')
                SendKeys.SendWait("{ENTER}")
            }
            
        }

    }
   
   
 