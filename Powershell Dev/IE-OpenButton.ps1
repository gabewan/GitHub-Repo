Clear-Host

$url = 'nghslink.nghs.com'

$ie = New-Object -com internetexplorer.application
$ie.visible = $true
$ie.navigate($url)

while ($ie.Busy -eq $true) { Start-Sleep -Seconds 1 }

($ie.document.getElementById('agencyIATA') | select -first 1).value = '1234567'
($ie.document.getElementById('agencyID ') | select -first 1).value = '789'
($ie.document.getElementById('bookingAgent') | select -first 1).value = '159'
($ie.document.getElementById('password') | select -first 1).value = '1234'

Start-Sleep -Seconds 2

($ie.Document.IHTMLDocument3_getElementsByTagName('button') `
|  Where-Object innerText -eq 'SIGN IN').Click()
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDWhJjMu9lgG7EOB5HhfO9I6H
# OxWgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQf13E7gPZbAq/C4kpVA93meb04LDAN
# BgkqhkiG9w0BAQEFAASCAQCZhyJezhDpwsiCsyN7CMFdztWdrZHIEmLxCiBg2inU
# Lqun7LhRTyTeQ9SGKY+A/BvgVO7XohAb7lh07KhEWQMWfa6khc8JSHN01NuxezO6
# 03SgtT0vCCk3egFLpx+sTFw8mcGU1/toLjPT/gCotnLH6P4xN72fI1Hpms4fIcfI
# 5DV9HOzwZi9kN58dBw+jz7q42d/MD9O7/P9bKMWx6/SqCd6Kk4RzA6iQi1jMt9Hh
# A5iNjZ/c4e4fHPMHu66bd38e2YR1dkCMBbNow7sD6gWfjT3vL+GrGKuVN+PJNMGQ
# abeVrH6yPR6Idr2gHT4FiZWBX2v2Vx9RZ2ztwKG4zYjh
# SIG # End signature block
