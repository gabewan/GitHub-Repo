string]$FilePath = "\\hqsbvnxfile1\Global\DMJ\PSData\printers.psobj"
$deserialized = [System.Management.Automation.PSSerializer]::Deserialize((Get-Content $FilePath))

$vmctxprn = $deserialized | select Port,VmcTxPrn

foreach($entry in $vmctxprn){
    $Printer = $entry.vmctxprn
    $Printer_IP = $entry.Port
    $Printer_Name = $Printer.Name

    $url = 'http://' + $ip + '/'
    if (Test-Connection $Printer_IP -Quiet) {
        $ie = New-Object -ComObject internetexplorer.application
        $ie.visible = $false
        $ie.navigate($url)
        Start-Sleep -Seconds 5
        $ie.refresh()
        Start-Sleep -Seconds 5
        # Check if Xerox VersaLink
        $xerox_versa_model = ($ie.Document.body.getElementsByTagName('span') | Where-Object {$_.ClassName -eq 'webui-globalNavigation-productName xux-app-branding-icon'}).TextContent
        $hp_LaserJet_400 = ($ie.Document.body.getElementsByTagName('td') | Where-Object {$_.ClassName -eq 'mastheadTitle'}).innerText
        $hp_LaserJet_2430 = ($ie.Document.body.getElementsByClassName('hpBannerTextBig') | select-object innerText).innerText

         if($xerox_versa_model -like "*Xerox® VersaLink®*"){
            $pwd = '1111'
            Write-Host "$Printer_Name - $Printer_IP is Xerox"
            $ie.Quit()
            <#
            ($ie.Document.body.getElementsByTagName('button') | Where-Object {$_.InnerText -like "Log In"}).Click()
            Start-Sleep 3
            ($ie.Document.body.getElementsByTagName('div') | Where-Object {$_.ClassName -like "xux-contactsTable-item*"}).Click()
            Start-Sleep 3
            ($ie.Document.getElementsByName('PSW')[1]).Value = $pwd
            Start-Sleep 3
            ($ie.Document.body.getElementsByTagName('button') | Where-Object {$_.Id -eq 'loginWithPswOK'}).Click()
            Start-Sleep 3
            ($ie.Document.body.getElementsByTagName('button') | Where-Object {$_.Id -like "openDeviceInfoDetailsModalWindow"}).Click()
            Start-Sleep 3
            $ie.Document.getElementById('deviceNameInput').Value = $Printer_Name
            Start-Sleep 3
            ($ie.Document.body.getElementsByTagName('button') | Where-Object {$_.Id -like "deviceDetailsSet"}).Click()
            Start-Sleep 3
            $ie.Navigate("$url" + "connectivity/index.html#hashNetwork/hashConnectivity")
            Start-Sleep 3
            ($ie.Document.body.getElementsByTagName('button') | Where-Object {$_.Id -like "commonEditButton"}).Click()
            Start-Sleep 3
            ($ie.Document.getElementsByName('hostname')[0]).Value = $name
            Start-Sleep 1
            ($ie.Document.body.getElementsByTagName('button') | Where-Object {$_.Id -like "saveButtonId"}).Click()
            Start-Sleep 3
            ($ie.Document.body.getElementsByTagName('button') | Where-Object {$_.Id -like "needRebootNow"}).Click()
            while((Test-Connection $port -Quiet) -eq $false){
                Start-Sleep 5
            }
            #>

        }else{
         Write-Host "."
        }

        <# if($hp_LaserJet_400 -like "*HP LaserJet 400*"){
            $ie.navigate("$url" + "set_config_netIdentification.html?tab=Networking&menu=NetIdent")
            "Sleeping"
            Start-Sleep 3
            ($ie.Document.body.getElementsByTagName('input') | Where-Object {$_.Name -like 'HostName'} | Select-Object -First 1).Value = $name
            Start-Job -ScriptBlock {
                Start-Sleep 5
                Add-Type -AssemblyName Microsoft.VisualBasic, System.Windows.Forms
                [Microsoft.VisualBasic.Interaction]::AppActivate('Message from webpage')
                [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
            }
            # Creates Javascript pop up to confirm information.
            ($ie.Document.body.getElementsByTagName('input') | Where-Object {$_.Id -like "apply_button"}).Click()

            Start-Sleep 3
            $ie.Refresh()

            Get-Job | Remove-Job
        } #>
        <#
        if ($hp_LaserJet_2430 -like "*hp LaserJet 2430*") {
            $ie.navigate($url + "hp/jetdirect")
            ($ie.Document.getElementsByTagName('input') | Where-Object {$_.Name -like 'IP_HostName'} | Select-Object -First 1).Value = $name
        }else{
            Write-Host "Unsupported Model"
        }
        #>      
    }
    
    
    #    $ie.Quit()
}