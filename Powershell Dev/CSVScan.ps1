$servers =  "vmctxprn","winprn","vbinprint"
 
$allprinters = @() 
foreach( $server in $servers ){ 
Write-Host "checking $server ..." 
$printer = $null 
$printers = $null 
$printers = Get-WmiObject -class Win32_Printer -computername $server 
$printer = $printers | where-object {$_.shared} 
#| select-object sharename, DriverName, PortName, SystemName, Location | Export-CSV .\process.csv  
$allprinters += $printer 
 } 
 Write-Host "exporting to printers.csv" 
$allprinters | select-object sharename, DriverName, PortName, SystemName, Location | Export-CSV .\printers.csv -NoTypeInformation 
Write-Host "Done!"
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURGVSM1fKGMCNkgKfh13kazxw
# P5+gggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSjiv6fDgzijHgQwkHveCUyviY1IjAN
# BgkqhkiG9w0BAQEFAASCAQBnb6KdxHIxoowYyXTL0jmjjDiof0scbc2sh1wCKv2E
# t3g/jmaYPCRx1gLar0S+2wUnGclBDqiO+mvKJaxJck9JV5j7JOtl/UAEtnxn52Rq
# nUbdvHSUZFS9dQnXtcSL8WPs2NAlEUPFiHt+cRhLeqFHPs/WdjCRWofkNQUumI0Y
# mwtnZRPs6xDAy/eT1yu9Rrk8sTnPjFNBK3aklPGA3ngvGVwxJtSIWb9M4cvlT7w9
# 6rU6LRWxlsLZnTpc6/IM2m2Uy6kDzdQgITwKOSh3zrlQa5cjlEaV9svEPg/RjxJU
# +C+pZa4Wm3PI0+QXl2eSZ9rxZt04l0ywbEOvR0hN33go
# SIG # End signature block
