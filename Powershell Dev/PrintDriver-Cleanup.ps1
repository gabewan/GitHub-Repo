$log = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\documents\Script Logs\PrintDriversBackup.csv"
$logpath = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\documents\Script Logs\DriverChangeLogs.csv"
$complete =  $array.GetEnumerator() | export-csv -path $log -Force 
$array=@{}


function Xerox-Global(){
$xeroxglobal = foreach($vmc in $vmc1){

$name = $vmc.name
$drivername = $vmc.drivername    

    if($drivername -like "Xerox Global*"){
      
        $key = $name
        $value = $drivername
        $array.add($key, $value)
      #Set-Printer -ComputerName VMCTXPRN -Name $name -DriverName "Xerox GPD PCL6 V3.9.520.6.0"
        } 
    }
}

function HP-LaserjetAll(){
$hplaserjet = foreach($vmc in $vmc1){

$name = $vmc.name
$drivername = $vmc.drivername    

    if($drivername -like "HP Laserjet*"){
      
        $key = $name
        $value = $drivername
        $array.add($key, $value)
      #Set-Printer -ComputerName VMCTXPRN -Name $name -DriverName "HP Universal Printing PCL 5"
        } 
    }
}

function HP-Universal6(){
    $hpuniversal6 = foreach($vmc in $vmc1){
        $name = $vmc.name
        $drivername = $vmc.drivername    
            if($drivername -like "HP Universal Printing PCL 5"){
                $key = $name
                $value = $drivername
                $array.add($key, $value)
                #Set-Printer -ComputerName VMCTXPRN -Name $name -DriverName "HP Universal Printing PCL 5"
        } 
    }
}


$vmcprint = get-printer -ComputerName winprn -name *
$winprint = get-printer -ComputerName vmctxprn -name *
#$winport = @(Get-PrinterPort -ComputerName winprn | select name)
$winport = $winprint.printerport
#$vmcport = @(Get-PrinterPort -ComputerName vmctxprn | select name)
$vmctxport = $vmcprint.printerport
#$vmcpdri = (get-printerdriver -ComputerName vmctxprn | select name)
$vmcpdri = $vmcprint.DriverName
#$winpdri = (Get-PrinterDriver -ComputerName winprn | select Name)
$winpdri = $winprint.DriverName
$cresult = Compare-Object -ReferenceObject $array1 -DifferenceObject $array2 -IncludeEqual
$presult = Compare-Object -ReferenceObject $vmcport -DifferenceObject $winport -IncludeEqual
$vmc1 = @(get-printer -ComputerName vmctxprn | select name,DriverName)
$max = ($vmcpdri, $winpdri, $winport, $vmcport, $vmcprint, $winprint | Measure-Object -Maximum -Property Count).Maximum    
$complete = 0..$max | Select-Object @{n="VMCTXPRN Drivers";e={$vmcpdri[$_]}}, @{n="WINPRN Drivers";e={$winpdri[$_]}}, @{n="VMCTXPRN Ports";e={$vmcport[$_]}}, @{n="WINPRN Ports";e={$winport[$_]}},@{n="VMCTXPRN Printers";e={$vmcprint[$_]}},@{n="WINPRN Printers";e={$winprint[$_]}}
export-csv -path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Documents\PrinterLogs.csv" -force


function Write-Log {

    [CmdletBinding()]

    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message = "$env:USERNAME,$env:COMPUTERNAME",

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information'
    
    )

    [pscustomobject]@{
        Time = (Get-Date -f g)
        Message = $message
        Severity = $Severity
    } | Export-Csv -Path $logpath -Append 

        

}

$complete
Write-Log



# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUJDz2+H/2i/zbdwYWImjTiGul
# A1GgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
# AQsFADAbMRkwFwYDVQQDDBBncmxld2lzQG5naHMuY29tMB4XDTE5MDIxODE2MTcz
# N1oXDTIwMDIxODE2MzczN1owGzEZMBcGA1UEAwwQZ3JsZXdpc0BuZ2hzLmNvbTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALW1WUSF3b+IwTQ7gk0Wx5Ap
# 12KUN8LgBQo7IdtDz6HDG/d3EU2gj27qjktOJI9ChnDdp4G5/8hNVPb9s2eIh5ae
# 1Cc/RHwFLu3WlIiEs5p7xbHprqR4gg8J3eEjHcY2FJxf+1NyLeov3CLWYRXfHgef
# ZqI0WJ1PEO6Jv5/VVWw0oMp2Od04PfH/rymHRh0yFSueOmfO/zxKcSM9/21C/n1Y
# B8ffpznvlY0smaikTkC7dubkX6GHU64ZDI69esh/KvPyX0m6e08130aIbaN3me0i
# lNmlBBqA52mVSIarDzY50HQHHF25zqgWqwYs0RSrwO20xwR33l2z7O3MpKZHGgkC
# AwEAAaNjMGEwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBsG
# A1UdEQQUMBKCEGdybGV3aXNAbmdocy5jb20wHQYDVR0OBBYEFB3t05KWOpdR18AN
# FF5Q6CIVBV94MA0GCSqGSIb3DQEBCwUAA4IBAQCU54GYx7ycvM7LHjgchGu2Gwak
# rY2AFJndoGyWB2D/B+uBpI3RxQKWZXaeEpKyUxGWfiFKyHLBfesNyCawzBIzkXxR
# QFZkS532tq9snNHmrX+dhw3cH5/ww/VwWyrvLq19I4wCS+1BTCwJUbetigDv+zlT
# bf/wXP5h13OC6clYRbTq0mTglqYXBlDVjFOwkI6MpvXwoKarggJ1N71HA2TqQpWU
# TA+6WgfEPiZDzpLig5ri6wSu1oVVq+YhP1yPDq+2OQ03SM04GdaUkWVkZnGqS6Ev
# d34IsRreZ6jF5LvSolXkXXfK9/1V11928ne/51iwjgMn7R5V2rhR+EnME6cvMYIB
# 0DCCAcwCAQEwLzAbMRkwFwYDVQQDDBBncmxld2lzQG5naHMuY29tAhBAsfjeyAfg
# gUi73gezXRteMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBR/ynPOPEYvq387HoLjoQkCNGL/yTAN
# BgkqhkiG9w0BAQEFAASCAQCsDZQ4h1+BuKgUQF+38J+jjjDGMSxTebLMcLZt/xsb
# B7LXNktxM2yBb3GsIWRGg49MeBdq/q7DoAwvp68uThDlwhyRjNIo3F7XLB+gakvD
# t2gF8PRDOA7fGPp+bvvrSdazua+Dx5Brp5Kb5OS1wB+QxzW3ksnqTEedzRAuiN4k
# 7RP1xo9dtkaLKXXOE50UfPT8KRuhTXphba0nV6D0X2yd1Mpo30ihfDh24182liK/
# RSJHGmiTaz9IxuNfaRexKagYde/zLulzWKSnHTsrWeTfCEyMK47Msvvs9vDW1VOp
# oC4xvJTu2usdT4YSChc2wcHv7FGDtEKajm8W+rdb7Qjo
# SIG # End signature block
