$import_print_selection_mp2 = Import-Csv C:\temp\Book1.csv # MEMBERS: Barcode,IP,MAC,Make
#HP M404DN
foreach ($object in $import_print_selection_mp2) {
    
    if ( $object.model -match "HP") {
        
        if (Test-Connection $object.IP -Count 1) {

            $url = 'http://' + $object.IP + '/'
        
            $ie = New-Object -ComObject internetexplorer.application
            $ie.visible = $true
            $ie.navigate($url)
            Start-Sleep -Seconds 4
            $ie.refresh()
            Start-Sleep -Seconds 4

            $model = ($ie.Document.body.getElementsByTagName('div') | where { $_.id -match "banner-section-title" }).TextContent

            $ie.Navigate("http://$($object.ip)/#hId-pgHostName")

            Start-Sleep -Seconds 3
            $sec_checkbox = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match 'tmpid2' }
            if ($sec_checkbox.checked -eq $false) {
                $sec_checkbox.checked = $true
            }

            $bypass_security = $ie.Document.body.getElementsByTagName('button') | where { $_.classname -match "gui" } -ErrorAction SilentlyContinue

            if ($bypass_security -ne $null) {
                Start-Sleep -Seconds 1
                $bypass_security.click()
                Start-Sleep -Seconds 2
            }

            $skip_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "More information" } -ErrorAction SilentlyContinue

            if ($skip_check -ne $null) {
                Start-Sleep -Seconds 1
                $skip_check.click()
                Start-Sleep -Seconds 1
                $skip_2_check = $ie.Document.body.getElementsByTagName('a') | where { $_.outertext -match "go on" }
                Start-Sleep -Seconds 1
                $skip_2_check.click()
                Start-Sleep -Seconds 3
            }

            #hostname
            $set_hostname = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid3-inp" }
            Start-Sleep -Seconds 2
            $set_hostname.value = $object.Barcode
            Start-Sleep -Seconds 1
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
            $ie.Navigate("http://$($object.ip)/#hId-pgDHCP")

            Start-Sleep -Seconds 4

            $check_FQDN = $ie.Document.body.getElementsByTagName('input') | where { $_.id -match "tmpid2" }
            if ($check_FQDN.checked -eq $false) {
                $check_FQDN.checked = $true
            }

            Start-Sleep -Seconds 3
            $button_applydnsname = $ie.Document.body.getElementsByTagName('input') | where { $_.classname -match "apply" }
            $button_applydnsname.click()
            Start-Sleep -Seconds 3
            $ie.quit()

        }
    }
}