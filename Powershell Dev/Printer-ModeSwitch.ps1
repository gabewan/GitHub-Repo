
 # helper function to locate a open program using by a given Window name
  Function FindWindow([string]$windowName, [int]$retries = 5, [int]$sleepInterval = 1000) {
    
    [int]$currentTry = 0;
    [bool]$windowFound = $false;
    
    Do {
      $currentTry++;
      
      Start-Sleep -Milliseconds $sleepInterval
      Try {
        [Microsoft.VisualBasic.Interaction]::AppActivate($windowName)
        $windowFound = $true;  
      } Catch {
        Write-Host "   [$currentTry out of $retries] failed to find Window with title '$windowName'" -ForegroundColor Yellow
        $windowFound = $false;
      }
    } While ($currentTry -lt $retries -and $windowFound -eq $false)
    

    return $windowFound;
  

  # import required assemblies
  Add-Type -AssemblyName Microsoft.VisualBasic
  Add-Type -AssemblyName System.Windows.Forms
 
  # first prompt to enter the password
  if(FindWindow("Windows Security")) {
    Start-Sleep -Milliseconds 500
    [System.Windows.Forms.SendKeys]::SendWait('admin{TAB}')  
    [System.Windows.Forms.SendKeys]::SendWait('1111{ENTER}')  
  }
}
  

#$printers = Get-Printer -ComputerName vmctxprn -Name * | where { $_.Name -match 'HP' -and $_.name -notmatch "XR" } | Sort-Object | select Name, Portname | select -first 50
$printers = Get-Printer -ComputerName vmctxprn -Name * | where { $_.Name -match '201SUR' } | Sort-Object | select Name, Portname

$vpsx = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\grlewis-repository\Logs\Export_VPSX.csv" | select Name, TCPHost #TCPHOST - PortName , NAME - PrinterName

$vpsx_results = @($vpsx)

$print_collector = [System.Collections.Generic.List[System.object]]::New()
$printer_col_comp = Import-Csv 'c:\temp\printer_modeswitch.csv'

$RX_EPIC = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'

foreach ($object in $printers) {

if (($printer_col_comp | where {$_.printer -match $object.name}).Completed -eq $true){
    Write-Host "$($object.name) has been completed already"
    continue
    }

    $printer_output = [pscustomobject]@{

        Printer    = $object.Name
        Port       = $null
        Model      = $null
        OldDNS     = $null
        NewDNS     = $null
        FixName    = $false
        Online     = $false
        Password   = $false
        VPSX       = $null
        Completed  = $false
    
    }

    if ($object.PortName -match '_') {

        if ($object.Portname -match '_1') {
            $object_port_trim = $object.Portname.ToString()
            $object_PT = $object_port_trim.Replace('_1', '')
            $printer_output.Port = $object_PT
        }

        if ($object.Portname -match '_2') {
            $object_port_trim = $object.Portname.ToString()
            $object_PT = $object_port_trim.Replace('_1', '')
            $printer_output.Port = $object_PT
        }
    }

    if ($object.Portname -notmatch '_') {

        $printer_output.Port = $object.Portname

    }
            

    if (Test-Connection $printer_output.Port -Quiet) {

        $printer_output.Online = "$true"

        $url = 'http://' + $printer_output.Port + '/'
        
        $ie = New-Object -ComObject internetexplorer.application
        $ie.visible = $true
        $ie.navigate($url)
        Start-Sleep -Seconds 4
        $ie.refresh()
        Start-Sleep -Seconds 4

        # Check Model: I am doing the highest count for models, the other few remaining devices will be done manually. 
        $Xerox_Versalink_B405DN_MFP = ($ie.Document.body.getElementsByTagName('span') | Where-Object { $_.ClassName -eq 'webui-globalNavigation-productName xux-app-branding-icon' }).TextContent
        $Xerox_VersaLink_B605X_MFP = ($ie.Document.body.getElementsByTagName('span') | Where-Object { $_.ClassName -eq 'webui-globalNavigation-productName xux-app-branding-icon' }).TextContent
        $Xerox_Altalink_C8055 = ($ie.Document.body.getElementsByTagName('span') | where { $_.outertext -match "Xerox® AltaLink™ C8055" }).OuterText
        $HP_LaserJet_400_M401dn = ($ie.Document.body.getElementsByTagName('td') | Where-Object { $_.ClassName -eq 'mastheadTitle' }).innerText
        $HP_LaserJet_400_M401n = ($ie.Document.body.getElementsByTagName('td') | Where-Object { $_.ClassName -eq 'mastheadTitle' }).innerText
        $HP_LaserJet_M402n = ($ie.Document.body.getElementsByTagName('td') | Where-Object { $_.ClassName -eq 'mastheadTitle' }).innerText
        $HP_LaserJet_2430 = ($ie.Document.body.getElementsByClassName('hpBannerTextBig') | select-object innerText).innerText
        $HP_LaserJet_404dn = ($ie.Document.body.getElementsByTagName('Div') | where { $_.ID -match 'banner-section-title' }).innerText
        $HP_Color_Laserjet_M452nw = ($ie.Document.body.getElementsByTagName('Div') | where { $_.outertext -match "hp color laserjet" }).OuterText
        $HP_Color_LaserJet_Pro_M454dn = ($ie.Document.body.getElementsByTagName('Div') | where { $_.ID -match 'banner-section-title' }).innerText
        $HP_Color_Laserjet_Pro_MFP_M479fdn = ($ie.Document.body.getElementsByTagName('Div') | where { $_.ID -match 'banner-section-title' }).innerText
        $HP_Color_LaserJet_M254dw = ($ie.Document.body.getElementsByTagName('*') | where { $_.Classname -match "mastheadTitle" }).OuterText
        $HP_LaserJet_200_color_M251nw = ($ie.Document.body.getElementsByTagName('td') | Where-Object { $_.ClassName -eq 'mastheadTitle' }).innerText
        


        #Model: Xerox AltaLink - Completed
        if ($Xerox_Altalink_C8055 -match "Xerox® AltaLink™ C8055 Multifunction Printer") {
            
            $printer_output.Model = "Xerox® AltaLink™ C8055 Multifunction Printer"
            <#$printer_output.Model = "Xerox AltaLink C8055 Multifunction Printer"
            $login_button = ($ie.Document.body.getElementsByTagName('button') | where { $_.textcontent -eq 'Login' })
            $login_button.click()
           Start-Sleep -Seconds 4
            
            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "GO ON TO THE WEBPAGE" }
            $skip_check.click($skip_check.ie8_href)
            Start-Sleep -Seconds 2

            #admin login : login button click : bodyclass
            try {
                $admin_login = $ie.Document.body.getElementsByTagName('input') | where { $_.name -eq 'frmwebUsername' }
                $admin_login.value = 'admin'
                $admin_password = $ie.Document.body.getElementsByTagName('input') | where { $_.name -eq 'frmwebPassword' }
                $admin_password.value = '7946130'
                $admin_button = ($ie.Document.body.getElementsByTagName('button') | where { $_.id -eq 'Loginbtn' })
                $admin_button.click()
                Start-Sleep -Seconds 2
            } 
            catch {
                $admin_login = $ie.Document.body.getElementsByTagName('input') | where { $_.name -eq 'frmwebUsername' }
                $admin_login.value = 'admin'
                $admin_password = $ie.Document.body.getElementsByTagName('input') | where { $_.name -eq 'frmwebPassword' }
                $admin_password.value = "1111"
                $admin_button = ($ie.Document.body.getElementsByTagName('button') | where { $_.id -eq 'Loginbtn' })
                $admin_button.click()
                $printer_output.Password = $true
                Start-Sleep -Seconds 2
            }

            #navigate to Connectivity. Bypasses the need to waste time on muliple clicks
            $ie.Navigate("http://$($printer_output.port)/protocols/ip/v4.php?from=wiredConfig")
            start-sleep -Seconds 2
            $prop_ip4 = $ie.Document.body.getElementsByTagName('button') | where { $_.outertext -match "Show IPv4 Settings" }
            $prop_ip4.click()

            #Set DHCP over Station Options. Set DNS if able
            $Set_DHCP = $ie.Document.body.getElementsByTagName('Div') | where { $_.outerhtml -match "frmAddResolut" -and $_.Classname -eq "menuWidgetDiv" }
            $set_select = $ie.Document.body.getElementsByTagName('select') | where { $_.classname -eq "menuWidget" -and $_.id -eq "frmAddResolut" }

            #$op_static = $ie.Document.body.getElementsByTagName('option') | where {$_.innerhtml -eq 'Static'}
            #$op_static.selected = $false
            $op_dhcp = $ie.Document.body.getElementsByTagName('option') | where { $_.innerhtml -eq 'dhcp' }
            $op_dhcp.selected = $true

            #Set DNS
            $prop_ip4 = $ie.Document.body.getElementsByTagName('button') | where { $_.outertext -match "Show DNS Settings" }
            $prop_ip4.click()
            $set_hostname = $ie.Document.body.getElementsByTagname('input') | where { $_.ID -match 'frmHostname_manual' }
            $printer_output.OldDNS = $set_hostname.value
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique
            
            if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
             $set_hostname.value = ($dns_vpsx|Out-String).ToUpper() 
             $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){

            $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
            $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            $printer_output.FixName = $true

            }
            $apply_settings = $ie.Document.body.getElementsByTagName('button') | where { $_.innertext -match 'apply' }
            $apply_settings.click()
            $ie.quit()
           #>
           $ie.quit()
                                            
        }
        #Model: Xerox Versalink B605x MFP
        if ($Xerox_VersaLink_B605X_MFP -match "Xerox® VersaLink® B605X MFP"){
            
            $printer_output.Model = "Xerox VersaLink B605X MFP"
            $login_button = $ie.Document.body.getElementsByTagName('button') | where { $_.ID -match "globalnavButton" }
            $login_button.click()
            Start-Sleep -Seconds 4
   
            try {
                $incorrectPass = $null
                $admin_login = $ie.Document.body.getElementsByTagName('div') | where { $_.ClassName -match "xux-contactsTable-item xux-applyBoxAndLayout-root xux-labelableBox xux-box xux-labelLayout-leading xux-itemLayout-vertical xux-contentLayout-trailing xux-style-list xux-labelIconOmittable-false xux-contentOmittable-false xux-kickable xux-contentMovable-true xux-verticalLayout-top xux-verticalLayout-bottom xux-topMargin-false xux-bottomMargin-false" }
                $admin_login.click()
                start-sleep -Seconds 2
                $admin_password = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "loginWithPswInput" }
                $admin_password.value = '7946130'
                $admin_button = ($ie.Document.body.getElementsByTagName('button') | where { $_.id -eq 'LoginWithPswOK' })
                $admin_button.click()
                Start-Sleep -Seconds 2
                $incorrectPass = ($ie.Document.body.getElementsByTagName('span') | where {$_.classname -match "xux-staticText xux-textOmittable-false xux-type-fault"}).OuterText

                if ($incorrectPass -ne $null) {
                    $printer_output.Password = $true
                    
                }
            } 
            catch {

                $admin_password = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "loginWithPswInput" }
                $admin_password.value = '1111'
                $admin_button = ($ie.Document.body.getElementsByTagName('button') | where { $_.id -eq 'LoginWithPswOK' })
                $admin_button.click()
                Start-Sleep -Seconds 3
            }

            $ie.Navigate("http://$($printer_output.port)/connectivity/index.html#hashNetwork/hashConnectivity")
            Start-Sleep -Seconds 5
            #Set DNS
            $button_common = $ie.Document.body.getElementsByTagName('button') | where { $_.ID -match "commonEditButton" }
            $button_common.click()

            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "hostname" }
            $printer_output.OldDNS = $set_hostname.value
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique
             
             if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }
            
             if ($printer_output.OldDNS -match $dns_vpsx) {
                  
                    continue
                }

             if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC){
                 
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()

                }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.FixName = $true
                }
             Start-Sleep -Seconds 2

            $button_ok =  $ie.Document.body.getElementsByTagName('button') | where {$_.textcontent -eq "ok"}
            $button_ok.click()
            Start-Sleep -Seconds 3

            $button_restart_later = $ie.Document.body.getElementsByTagName('button') | where {$_.OuterText -match "Restart Later"}
            $button_restart_later.click()
            Start-Sleep -Seconds 2

            #Set DHCP over Station Options. Set DNS if able
            $Button_EditIPv4 = $ie.Document.body.getElementsByTagName('Button') | where { $_.ID -match "IPv4ButtonEthernet1" }
            $Button_EditIPv4.click() 
            Start-Sleep -Seconds 1
            $select_options = $ie.Document.body.getElementsByTagName('select') | where { $_.ID -eq "ipv4DropdownList" }
            $default_DHCP = $select_options | where {$_.Selected -eq $true}
            #Disable Static, Set DHCP
            if ($default_DHCP.selected -eq 'manualdropdown') {

                $options_static = $select_options | where { $_.ID -match 'manualdropdown' }
                $options_dhcp = $select_options | where { $_.ID -match "DHCPDropdown" }

                $options_static.selected = $false
                $options_static.defaultselected = $false

                $options_dhcp.selected = $true
                $options_dhcp.defaultselected = $true
                $printer_output.Static = $false
            }

            $button_ok =  $ie.Document.body.getElementsByTagName('button') | where {$_.textcontent -eq "ok"}
            $button_ok.click()

            Start-Sleep -Seconds 3

            $button_restart_now = $ie.Document.body.getElementsByTagName('button') | where {$_.OuterText -match "Restart Now"}
            $button_restart_now.click()
            $ie.quit()
    
        }
        #MODEL: Xerox VersaLink - Completed
        if ($Xerox_Versalink_B405DN_MFP -match "Xerox® VersaLink™ B405DN MFP") {

            $printer_output.model = "Xerox VersaLink B405DN MFP"
            $login_button = $ie.Document.body.getElementsByTagName('button') | where { $_.ID -match "globalnavButton" }
            $login_button.click()
            Start-Sleep -Seconds 4
   
            try {
                $incorrectPass = $null
                $admin_login = $ie.Document.body.getElementsByTagName('div') | where { $_.ClassName -match "xux-contactsTable-item xux-applyBoxAndLayout-root xux-labelableBox xux-box xux-labelLayout-leading xux-itemLayout-vertical xux-contentLayout-trailing xux-style-list xux-labelIconOmittable-false xux-contentOmittable-false xux-kickable xux-contentMovable-true xux-verticalLayout-top xux-verticalLayout-bottom xux-topMargin-false xux-bottomMargin-false" }
                $admin_login.click()
                start-sleep -Seconds 2
                $admin_password = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "loginWithPswInput" }
                $admin_password.value = '7946130'
                $admin_button = ($ie.Document.body.getElementsByTagName('button') | where { $_.id -eq 'LoginWithPswOK' })
                $admin_button.click()
                Start-Sleep -Seconds 2
                $incorrectPass = ($ie.Document.body.getElementsByTagName('span') | where {$_.classname -match "xux-staticText xux-textOmittable-false xux-type-fault"}).OuterText

                if ($incorrectPass -ne $null) {
                    $printer_output.Password = $true
                    
                }
            } 
            catch {

                $admin_password = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "loginWithPswInput" }
                $admin_password.value = '1111'
                $admin_button = ($ie.Document.body.getElementsByTagName('button') | where { $_.id -eq 'LoginWithPswOK' })
                $admin_button.click()
                Start-Sleep -Seconds 3
            }

            $ie.Navigate("http://$($printer_output.port)/connectivity/index.html#hashNetwork/hashConnectivity")
            Start-Sleep -Seconds 5
            #Set DNS
            $button_common = $ie.Document.body.getElementsByTagName('button') | where { $_.ID -match "commonEditButton" }
            $button_common.click()
            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "hostname" }
            $printer_output.OldDNS = $set_hostname.value
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

            if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }
            
             if ($printer_output.OldDNS -match $dns_vpsx) {
                  
                    continue
                }

             if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC){
                 
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
                }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.FixName = $true
                }

            Start-Sleep -Seconds 2
            $button_ok =  $ie.Document.body.getElementsByTagName('button') | where {$_.textcontent -eq "ok"}
            $button_ok.click()
            Start-Sleep -Seconds 3
            $button_restart_later = $ie.Document.body.getElementsByTagName('button') | where {$_.OuterText -match "Restart Later"}
            $button_restart_later.click()
            Start-Sleep -Seconds 2

            #Set DHCP over Station Options. Set DNS if able
            $Button_EditIPv4 = $ie.Document.body.getElementsByTagName('Button') | where { $_.ID -match "IPv4ButtonEthernet1" }
            $Button_EditIPv4.click() 
            Start-Sleep -Seconds 1
            $select_options = $ie.Document.body.getElementsByTagName('select') | where { $_.ID -eq "ipv4DropdownList" }
            $default_DHCP = $select_options | where {$_.Selected -eq $true}
            #Disable Static, Set DHCP
            if ($default_DHCP.selected -eq 'manualdropdown') {

                $options_static = $select_options | where { $_.ID -match 'manualdropdown' }
                $options_dhcp = $select_options | where { $_.ID -match "DHCPDropdown" }

                $options_static.selected = $false
                $options_static.defaultselected = $false

                $options_dhcp.selected = $true
                $options_dhcp.defaultselected = $true
                $printer_output.Static = $false
            }

            $button_ok =  $ie.Document.body.getElementsByTagName('button') | where {$_.textcontent -eq "ok"}
            $button_ok.click()

            Start-Sleep -Seconds 3

            $button_restart_now = $ie.Document.body.getElementsByTagName('button') | where {$_.OuterText -match "Restart Now"}
            $button_restart_now.click()
            $ie.quit()
        }
        #Model: HP LaserJet M402n
        if ($HP_LaserJet_M402n -match "HP LaserJet M402n"){

            $printer_output.Model = "HP LaserJet M402n"
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

            if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

            $ie.Navigate("http://$($printer_output.port)/set_config_netIdentification.html?tab=Networking&menu=NetIdent")
            Start-Sleep -Seconds 2

            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -eq "Hostname" }

            $printer_output.OldDNS = $set_hostname.value

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
        
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply_button" }
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
    
            $ie.Navigate("http://$($printer_output.port)/hp/device/set_config_IP.html?tab=Networking&menu=NetIPv4Config")
            Start-Sleep -Seconds 2

            $set_dhcp = ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "prefered" }).Value
            if ($Set_DHCP -match "PrefManual") {
                ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "prefered" }).ie9_value = 'PrefDHCP'
                $printer_output.Static = $false
            }
            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply" }
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
            $printer_output.Completed = $true
            $ie.quit()

        }
        #Model: HP LaserJet M402n - Completed
        if ($HP_LaserJet_400_M401n -match "HP LaserJet 400 M401n") {

            $printer_output.Model = "HP LaserJet 400 M401n"
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

            if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

            $ie.Navigate("http://$($printer_output.port)/set_config_netIdentification.html?tab=Networking&menu=NetIdent")
            Start-Sleep -Seconds 2

            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -eq "Hostname" }

            $printer_output.OldDNS = $set_hostname.value

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
        
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply_button" }
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
    
            $ie.Navigate("http://$($printer_output.port)/hp/device/set_config_IP.html?tab=Networking&menu=NetIPv4Config")
            Start-Sleep -Seconds 2

            $set_dhcp = ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "prefered" }).Value
            if ($Set_DHCP -match "PrefManual") {
                ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "prefered" }).ie9_value = 'PrefDHCP'
                $printer_output.Static = $false
            }
            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply" }
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
            $printer_output.Completed = $true
            $ie.quit()


        }
        #Model: HP LaserJet 400 M401dn
        if ($HP_LaserJet_400_M401dn -match "HP LaserJet 400 M401dn"){

            $printer_output.Model = "HP LaserJet 400 M401dn"
        $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

              if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

        $ie.Navigate("http://$($printer_output.port)/set_config_networkIdent.html?tab=Networking&menu=NetIdent")
        if(FindWindow("Windows Security")) {
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('admin{TAB}')  
        [System.Windows.Forms.SendKeys]::SendWait('1111{ENTER}')  
         }
        Start-Sleep -Seconds 2

        $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -eq "Hostname" }

        $printer_output.OldDNS = $set_hostname.value

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
        
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where {$_.name -eq "apply"}
            $apply_settings.click()
            Start-Sleep -Seconds 3
         $ie.Navigate("http://$($printer_output.port)/hp/device/set_config_networkIP.html?tab=Networking&menu=NetIPv4Config")

         
          $check_manual = ($ie.Document.body.getElementsByTagName('input') | where {$_.name -match "IPConfig" -and $_.value -match "EWS_MANUAL"}).Checked
          $check_auto = $ie.Document.body.getElementsByTagName('input') | where {$_.name -match "IPConfig" -and $_.value -match "EWS_Auto"}
          $set_dhcp = $ie.Document.body.getElementsByTagName('input') | where {$_.name -match "DHCP"}

            if ($check_manual -eq $true) {
                $check_auto.checked = $true
                $set_dhcp.checked = $true
                $printer_output.Static = $false
                
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.name -match "apply" }
            #$apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
            $printer_output.Completed = $true
            $apply_set_check = $ie.Document.body.getElementsByTagName('input') | where {$_.name -match "clear"}
            $apply_set_check.click()
            $ie.quit()



        }
        #Model: HP LaserJet M404dn - Completed
        if ($hp_laserjet_404dn -match "HP Laserjet Pro M404dn") {

            $printer_output.Model = "HP LaserJet Pro M404dn"
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

            if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

            $ie.Navigate("http://$($printer_output.port)/#hId-pgHostName")
            Start-Sleep -Seconds 2

            $bypass_security = $ie.Document.body.getElementsByTagName('button') | where { $_.classname -match "gui" } -ErrorAction SilentlyContinue

            if ($bypass_security -ne $null) {
                $check_sec_box = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmp" }
                $check_sec_box.status = $true
                Start-Sleep -Seconds 1
                $bypass_security.click()
                Start-Sleep -Seconds 2
            }

            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" } -ErrorAction SilentlyContinue
            #$skip_check_button = $ie.Document.body.getElementsByTagName('A') | where {$_.OuterText -match "Go on to the webpage"}

            if ($skip_check -ne $null) {
                Start-Sleep -Seconds 1
                $skip_check.click($skip_check)
                Start-Sleep -Seconds 1
                $skip_2_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "go on" }
                Start-Sleep -Seconds 1
                $skip_2_check.click($skip_2_check)
                Start-Sleep -Seconds 3
            }

            #hostname
            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid3-inp" }
            Start-Sleep -Seconds 2
            $printer_output.OldDNS = $set_hostname.value

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
                Start-Sleep -Seconds 1
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            $button_applydnsname = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "apply" }
            Start-Sleep -Seconds 1
            $button_applydnsname.click()
            Start-Sleep -Seconds 1
            $cert_clear = $ie.Document.body.getElementsByTagName('button') | where { $_.classname -match "gui" } -ErrorAction SilentlyContinue

            if ($cert_clear -ne $null) {
                Start-Sleep -Seconds 1
                $cert_clear.click()
            }
            Start-Sleep -Seconds 5

            $signin = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "ok_btn" }
            $signin.click()
            Start-Sleep -Seconds 5

            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" } -ErrorAction SilentlyContinue
            if ($skip_check -ne $null) {
                #Security Bypass
                $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" }
                Start-Sleep -Seconds 1
                $skip_check.click()
                Start-Sleep -Seconds 1
                $skip_2_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "go on" }
                Start-Sleep -Seconds 1
                $skip_2_check.click()
            }

            #set DHCPv4 FQDN 
            Start-Sleep -Seconds 3
            $ie.Navigate("http://$($printer_output.Port)/#hId-pgDHCP")

            Start-Sleep -Seconds 4

            $check_FQDN = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid2" }
            if ($check_FQDN.checked -eq $false) {
                $check_FQDN.checked = $true
            }

            Start-Sleep -Seconds 3
            $button_applydnsname = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "apply" }
            $button_applydnsname.click()
            Start-Sleep -Seconds 3
            $printer_output.Completed = $true
            $ie.quit()
      
        }
        #Model: HP Color LaserJet Pro MFP M479fdn - Completed
        if ($HP_Color_Laserjet_Pro_MFP_M479fdn -match "HP Color LaserJet Pro MFP M479fdn") {

            $printer_output.Model = "HP Color LaseJet Pro mfp M479fdn"
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

          if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

            $ie.Navigate("http://$($printer_output.port)/#hId-pgHostName")
            Start-Sleep -Seconds 2

            $bypass_security = $ie.Document.body.getElementsByTagName('button') | where { $_.classname -match "gui" } -ErrorAction SilentlyContinue

            if ($bypass_security -ne $null) {
                $check_sec_box = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmp" }
                $check_sec_box.status = $true
                Start-Sleep -Seconds 1
                $bypass_security.click()
                Start-Sleep -Seconds 2
            }

            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" } -ErrorAction SilentlyContinue
            #$skip_check_button = $ie.Document.body.getElementsByTagName('A') | where {$_.OuterText -match "Go on to the webpage"}

            if ($skip_check -ne $null) {
                Start-Sleep -Seconds 1
                $skip_check.click($skip_check)
                Start-Sleep -Seconds 1
                $skip_2_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "go on" }
                Start-Sleep -Seconds 1
                $skip_2_check.click($skip_2_check)
                Start-Sleep -Seconds 3
            }

            #hostname
            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid3-inp" }
            Start-Sleep -Seconds 2
            $printer_output.OldDNS = $set_hostname

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
                Start-Sleep -Seconds 1
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            $button_applydnsname = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "apply" }
            Start-Sleep -Seconds 1
            $button_applydnsname.click()
            Start-Sleep -Seconds 1
            $cert_clear = $ie.Document.body.getElementsByTagName('button') | where { $_.classname -match "gui" } -ErrorAction SilentlyContinue

            if ($cert_clear -ne $null) {
                Start-Sleep -Seconds 1
                $cert_clear.click()
            }
            Start-Sleep -Seconds 5

            $signin = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "ok_btn" }
            $signin.click()
            Start-Sleep -Seconds 5

            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" } -ErrorAction SilentlyContinue
            if ($skip_check -ne $null) {
                #Security Bypass
                $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" }
                Start-Sleep -Seconds 1
                $skip_check.click()
                Start-Sleep -Seconds 1
                $skip_2_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "go on" }
                Start-Sleep -Seconds 1
                $skip_2_check.click()
            }

            #set DHCPv4 FQDN 
            Start-Sleep -Seconds 3
            $ie.Navigate("http://$($printer_output.Port)/#hId-pgDHCP")

            Start-Sleep -Seconds 4

            $check_FQDN = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid2" }
            if ($check_FQDN.checked -eq $false) {
                $check_FQDN.checked = $true
            }

            Start-Sleep -Seconds 3
            $button_applydnsname = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "apply" }
            $button_applydnsname.click()
            Start-Sleep -Seconds 3
            $printer_output.Completed = $true
            $ie.quit()
      
        }
        #Model: HP Color LaserJet Pro MFP M54dn
        if ($HP_Color_LaserJet_Pro_M454dn -match "HP Color LaserJet Pro M454dn") {

            $printer_output.Model = "HP Color LaserJet Pro M454dn"
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

          if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

            $ie.Navigate("http://$($printer_output.port)/#hId-pgHostName")
            Start-Sleep -Seconds 2

            $bypass_security = $ie.Document.body.getElementsByTagName('button') | where { $_.classname -match "gui" } -ErrorAction SilentlyContinue

            if ($bypass_security -ne $null) {
                $check_sec_box = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmp" }
                $check_sec_box.status = $true
                Start-Sleep -Seconds 1
                $bypass_security.click()
                Start-Sleep -Seconds 2
            }

            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" } -ErrorAction SilentlyContinue
            #$skip_check_button = $ie.Document.body.getElementsByTagName('A') | where {$_.OuterText -match "Go on to the webpage"}

            if ($skip_check -ne $null) {
                Start-Sleep -Seconds 1
                $skip_check.click($skip_check)
                Start-Sleep -Seconds 1
                $skip_2_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "go on" }
                Start-Sleep -Seconds 1
                $skip_2_check.click($skip_2_check)
                Start-Sleep -Seconds 3
            }

            #hostname
            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid3-inp" }
            Start-Sleep -Seconds 2
            $printer_output.OldDNS = $set_hostname

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
                Start-Sleep -Seconds 1
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            $button_applydnsname = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "apply" }
            Start-Sleep -Seconds 1
            $button_applydnsname.click()
            Start-Sleep -Seconds 1
            $cert_clear = $ie.Document.body.getElementsByTagName('button') | where { $_.classname -match "gui" } -ErrorAction SilentlyContinue

            if ($cert_clear -ne $null) {
                Start-Sleep -Seconds 1
                $cert_clear.click()
            }
            Start-Sleep -Seconds 5

            $signin = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "ok_btn" }
            $signin.click()
            Start-Sleep -Seconds 5

            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" } -ErrorAction SilentlyContinue
            if ($skip_check -ne $null) {
                #Security Bypass
                $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" }
                Start-Sleep -Seconds 1
                $skip_check.click()
                Start-Sleep -Seconds 1
                $skip_2_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "go on" }
                Start-Sleep -Seconds 1
                $skip_2_check.click()
            }

            #set DHCPv4 FQDN 
            Start-Sleep -Seconds 3
            $ie.Navigate("http://$($printer_output.Port)/#hId-pgDHCP")

            Start-Sleep -Seconds 4

            $check_FQDN = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid2" }
            if ($check_FQDN.checked -eq $false) {
                $check_FQDN.checked = $true
            }

            Start-Sleep -Seconds 3
            $button_applydnsname = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "apply" }
            $button_applydnsname.click()
            Start-Sleep -Seconds 3
            $printer_output.Completed = $true
            $ie.quit()
      
        }
        #Model: HP Color LaserJet M452nw - Completed
        if ($HP_Color_Laserjet_M452nw -match "HP Color LaserJet M452nw") {

            $printer_output.Model = "HP Color LaserJet M452nw"
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

            if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

            $ie.Navigate("http://$($printer_output.port)/set_config_netIdentification.html?tab=Networking&menu=NetIdent")
            Start-Sleep -Seconds 2

            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -eq "Hostname" }

            $printer_output.OldDNS = $set_hostname.value

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
        
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply_button"}
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
    
            $ie.Navigate("http://$($printer_output.port)/hp/device/set_config_IP.html?tab=Networking&menu=NetIPv4Config")
            Start-Sleep -Seconds 4
            #Options: DHCP/AUTO/MANUAL
            $set_dhcp = ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "preferedMethodSelection" }).Value

            if ($Set_DHCP -match "PrefManual|PrefBootP|PrefAutoIP") {
                ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "prefered" }).ie9_value = 'PrefDHCP'
                #$printer_output.Static = $false
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply" }
            Start-Sleep -Seconds 1
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
            $printer_output.Completed = $true
            $ie.quit()


        } 
        #Model: HP Color LaserJet M254dw - Completed
        if ($HP_Color_LaserJet_M254dw -match "HP Color LaserJet M254dw"){
          $printer_output.Model = "HP Color LaserJet M254dw"
            $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

            if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

            $ie.Navigate("http://$($printer_output.port)/set_config_netIdentification.html?tab=Networking&menu=NetIdent")
            Start-Sleep -Seconds 2

            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -eq "Hostname" }

            $printer_output.OldDNS = $set_hostname.value

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
        
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            $printer_output.FixName = $true
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply_button" }
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
    
            $ie.Navigate("http://$($printer_output.port)/hp/device/set_config_IP.html?tab=Networking&menu=NetIPv4Config")
            Start-Sleep -Seconds 2

            $set_dhcp = ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "prefered" }).Value
            if ($Set_DHCP -match "PrefManual") {
                ($ie.Document.body.getElementsByTagName('select') | where { $_.name -match "prefered" }).ie9_value = 'PrefDHCP'
                $printer_output.Static = $false
            }
            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -match "apply" }
            $apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
            $printer_output.Completed = $true
            $ie.quit()
        }
        #Model: HP LaserJet 200 color M251nw
        if ($HP_LaserJet_200_color_M251nw -match "HP LaserJet 200 color M251nw"){
         $printer_output.Model = "HP LaserJet 200 color M251nw"
         $ie.quit()
        continue
        <#
            $printer_output.Model = "HP LaserJet 200 color M251nw"
        $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique

              if ($dns_vpsx.count -gt '1'){
                
                $dns_vpsx = ($vpsx_results | where { $_.TCPHost -match $printer_output.port }).Name | select -Unique -First 1
                $printer_output.VPSX = "$($printer_output.name) : duplicate entries"
                }

        $ie.Navigate("http://$($printer_output.port)/set_config_networkIdent.html?tab=Networking&menu=NetIdent")
        if(FindWindow("Windows Security")) {
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('admin{TAB}')  
        [System.Windows.Forms.SendKeys]::SendWait('1111{ENTER}')  
         }
        Start-Sleep -Seconds 2

        $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.ID -eq "Hostname" }

        $printer_output.OldDNS = $set_hostname.value

            if ($dns_vpsx -ne $null -and $dns_vpsx -match $RX_EPIC) {
        
                $set_hostname.value = ($dns_vpsx|Out-String).ToUpper()
                $printer_output.NewDNS = ($dns_vpsx|Out-String).ToUpper()
            }

            if ($dns_vpsx -ne $null -and $dns_vpsx -notmatch $RX_EPIC){
            $printer_output.NewDNS = $false
            }

            #Check DHCP_V4 DNS Name
            $dhcp_radio_DHCPv4 = ($ie.Document.body.getElementsByTagName('input') | where {$_.name -match "HostNamePriority" -and $_.value -match "DHCPv4_HOSTNAME"}).Checked = $true
            Start-Sleep -Seconds 1
            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where {$_.name -eq "apply"}
            $apply_settings.click()
            Start-Sleep -Seconds 3
            $ie.Navigate("http://$($printer_output.port)/hp/device/set_config_networkIP.html?tab=Networking&menu=NetIPv4Config")

         
          $check_manual = ($ie.Document.body.getElementsByTagName('input') | where {$_.name -match "IPConfig" -and $_.value -match "EWS_MANUAL"}).Checked
          $check_auto = $ie.Document.body.getElementsByTagName('input') | where {$_.name -match "IPConfig" -and $_.value -match "EWS_Auto"}
          $set_dhcp = $ie.Document.body.getElementsByTagName('input') | where {$_.name -match "DHCP"}
          Start-Sleep -Seconds 2
            if ($check_manual -eq $true) {
                $check_auto.checked = $true
                $set_dhcp.checked = $true
                $printer_output.Static = $false
                
            }

            $apply_settings = $ie.Document.body.getElementsByTagName('input') | where { $_.name -match "apply" }
            #$apply_settings.onclick = $null
            $apply_settings.click()
            Start-Sleep -Seconds 2
            $printer_output.Completed = $true
            $apply_set_check = $ie.Document.body.getElementsByTagName('input') | where {$_.name -match "clear"}
            $apply_set_check.click()
            $ie.quit()
            #>


        }

        $ie.quit()
        $print_collector.Add($printer_output)
    }
  }

$print_collector | Export-Csv 'c:\temp\printer_modeswitch.csv' -Force -Append