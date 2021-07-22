
$Get_Printers = Import-Csv "\\hqsbvnxfile1\global\grlewis\logs\ZebraPrinters_ZebraDNSCHange.csv" | select -First 10
$Export_Inventory = New-Object System.Collections.ArrayList
$REG_EX_Filter = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'

foreach ($Portname in $Get_Printers){

    $Array_Inventory = "" | Select-Object 'Printer','IP','Old_netBios','netBios','Completed' #Create a storage array 
    $Portname_Clean =  $Portname.IP
    $Name_Clean = $Portname.'Printer Name'

    if (Test-Connection $Portname_Clean -Count 1 -ErrorAction SilentlyContinue){

        $Portname_New = $Portname_Clean
        $Name = $Name_Clean

         if ($Name -match $REG_EX_Filter){

            $ie = New-Object -ComObject internetexplorer.application
            Start-Sleep 1
            $ie.visible = $true
            Start-Sleep 1
            $ie.Navigate("http://$Portname_New/settings")
            Start-Sleep 1
            $Password_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'Password'} -ErrorAction SilentlyContinue

            Write-Host $Password_IE.type

            if ($Password_IE.type -eq "password"){

                    $Password_IE.value = "1234"
                    Start-Sleep 1
                    $submitButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit'}
                    Start-Sleep 2
                    $submitButton.click()
                    Start-Sleep 1
                    Write-Host "password entered"
                    $ie.Quit()
                    $ie = New-Object -ComObject internetexplorer.application
                    Start-Sleep 1
                    $ie.visible = $true
            } 

            $ie.Navigate("http://$Portname_New/setgen")
            Start-Sleep 2
            $netBios_name = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -eq "0"}
            Start-Sleep 2
            $old_netbios = $netbios_name.value
            Write-Host $old_netbios
            $netBios_name.value = $Name
            Start-Sleep 2
            $submitButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit'}
            Start-Sleep 2
            $submitButton.click()
            Start-Sleep 3
            $ie.Navigate("http://$Portname_New/settings")
            Start-Sleep 2
            $resetButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.value -eq 'reset network'}
            Start-Sleep 2
            $resetButton.click()
            Start-Sleep 3
            $Completed = "Yes"            
            $ie.Quit()
        
        $Array_Inventory.Printer = $Name
        $Array_Inventory.IP = $Portname_New
        $Array_Inventory.Old_netBios = $old_netbios
        $Array_Inventory.netBios = $Name
        $Array_Inventory.Completed = $Completed
        $Export_Inventory.Add($Array_Inventory) | Out-Null
    } 
  }
}

$Export_Inventory | Export-Csv "C:\temp\Export_ZebraDevices.csv" -Force -NoTypeInformation