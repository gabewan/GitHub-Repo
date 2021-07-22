$vpsx = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\grlewis-repository\Logs\Export_VPSX.csv" 

$printerset = $vpsx | where {$_.name -like "*ZP*"} | select name,tcphost 

$vpsx_results = @($vpsx)

$zebra_obj = [System.Collections.Generic.List[System.object]]::New()
$zebra_objects = Import-Csv C:\temp\zebra_export_OBJECTS.csv
$zebra_obj.Add($zebra_objects)

$zebra_noncompleted = $zebra_obj | where {$_.completed -eq $false}
$REG_EX_Filter = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'
###################################################################################
foreach ($zebra_printer in $printerset){

    if (($zebra_obj | where {$_.zebra -match $zebra_printer.name}).Completed -eq $true){
    Write-Host " $($zebra_printer.name) is completed already."
    continue
    }
 
    $zebra_output = [pscustomobject]@{

                    Zebra         = $zebra_printer.Name
                    IPAddress     = $zebra_printer.TCPHOST
                    DNS           = $null
                    OldDNS        = $null
                    Online        = $null 
                    Completed     = $false

                }
    

    if (Test-Connection $zebra_printer.tcphost -Count 1 -ErrorAction SilentlyContinue){
        
        $zebra_output.Online = "$true"
        $Port = $zebra_printer.tcphost
        $Name = $zebra_printer.name

         if ($Name -match $REG_EX_Filter){

            $ie = New-Object -ComObject internetexplorer.application
            Start-Sleep 1
            $ie.visible = $true
            Start-Sleep 1
            $ie.Navigate("http://$Port/settings")
            Start-Sleep 1
            $Password_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'Password'} -ErrorAction SilentlyContinue 

            if ($Password_IE.type -eq "password"){

                    $Password_IE.value = "1234"
                    Start-Sleep 1
                    $submitButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit'}
                    Start-Sleep 2
                    $submitButton.click()
                    Start-Sleep 1
                    $ie.Quit()
                    $ie = New-Object -ComObject internetexplorer.application
                    Start-Sleep 1
                    $ie.visible = $true
            } 

            $ie.Navigate("http://$Port/setgen")
            Start-Sleep 2
            $netBios_name = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -eq "0"}
            Start-Sleep 2
            $old_netbios = $netbios_name.value
            $zebra_output.OldDNS = $old_netbios
            $netBios_name.value = $Name
            Start-Sleep 2
            $submitButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit'}
            Start-Sleep 2
            $submitButton.click()
            Start-Sleep 3 

        $zebra_output.DNS = $Name
        $zebra_obj.Add($zebra_output)
    } 

         if ($Name -notmatch $REG_EX_Filter){
         
            $z_vpsx = ($vpsx_results | where {$_.TCPHOST -match $Port}).Name
            
             $ie = New-Object -ComObject internetexplorer.application
            Start-Sleep 1
            $ie.visible = $true
            Start-Sleep 1
            $ie.Navigate("http://$Port/settcpip")
            Start-Sleep 1
            $Password_IE = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'Password'} -ErrorAction SilentlyContinue

            if ($Password_IE.type -eq "password"){

                    $Password_IE.value = "1234"
                    Start-Sleep 1
                    $submitButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit'}
                    Start-Sleep 2
                    $submitButton.click()
                    Start-Sleep 1
                    $ie.Quit()
                    $ie = New-Object -ComObject internetexplorer.application
                    Start-Sleep 1
                    $ie.visible = $true
            } 

            $ie.Navigate("http://$Port/setgen")
            Start-Sleep 2
            $netBios_name = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -eq "0"}
            Start-Sleep 2
            $old_netbios = $netbios_name.value
            $zebra_output.OldDNS = $old_netbios
            $netBios_name.value = $z_vpsx
            Start-Sleep 2
            $submitButton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit'}
            Start-Sleep 2
            $submitButton.click()
            Start-Sleep 3
            $zebra_output.DNS = $z_vpsx
            $zebra_obj.Add($zebra_output)
         
         }

            $ie.Navigate("http://$Port/settcpip")
            Start-Sleep 1
            $select_options = $ie.document.IHTMLDocument3_getElementsByTagName('select') | where {$_.innertext -match "BOOTP DHCP"}
            $op_DHCP = $select_options | where {$_.text -eq "DHCP"}

            if ($op_DHCP.selected -eq $false){
                $op_DHCP.selected = $true
                $submitbutton = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.value -match "Submit"}
                $submitButton.click()
                Start-Sleep -Seconds 2
                $continue_link = $ie.document.IHTMLDocument3_getElementsByTagName('A') | where {$_.host -match "$port"}
                $continue_link.click()
                Start-Sleep -Seconds 2
                $save_configuration = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.value -match "Save Current Configuration"}
                $save_configuration.click()
                $ie.Quit()
                $zebra_output.completed = $true
                Start-Sleep -Seconds 40
            } else {
            $ie.Quit()
            $zebra_output.completed = $true
            Start-Sleep -Seconds 40
            }
  }
    else {
    
    $zebra_output.Online = "$false"
    $zebra_output.DNS = "$fasle"
    $zebra_obj.Add($zebra_output)
    continue
    }
}

$zebra_obj | Export-Csv -Path 'C:\temp\zebra_export_OBJECTS.csv' -Force -Append

#LastRan: 7.6.2020