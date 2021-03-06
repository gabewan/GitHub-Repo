$hn = Read-Host "Enter Computer Name:"
$un = Read-Host "Enter UserName:"
$OL = Get-Process -ComputerName $hn -Name OUTLOOK -ErrorAction Ignore
$rsrs = Remove-Item "\\$hn\c$\users\$un\AppData\Roaming\Microsoft\Outlook\Outlook.srs" -Force -ErrorAction Ignore

Get-Process -ComputerName $hn -Name OUTLOOK -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
$rsrs
Invoke-Command –ComputerName $hn -ScriptBlock {Start-Process OUTLOOK -ErrorAction SilentlyContinue}






    

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUI+z375hseSR2x4IBpBX22wDo
# bCqgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQ2FNoBgxw+XOUKKbxoAKPbqFoG9DAN
# BgkqhkiG9w0BAQEFAASCAQCzVhVGPn+Yow2+6JFMIvlMq1gm8aNs5lVYLeovLP82
# mkY+GRr6yd30RLHB8vDLshIVWbHuluYY4c72S6nmtAdXBdZwl/8c0TYYuujYxRwZ
# jwr8ZBqx6NDxmizVdujTSc+EbCqY6xeWwV8gPa3ISBDgNrHt5bWwUnbGwUs26rpv
# 0u4tJcjmpXIPqz316WW+LtV5+MBiyxy71mhpqGlsmrFc4VenERlEY+69CO4fMpsO
# PdSSHG8jrQeC3lQbAnSTV75Xsupfm6YGd/dPKsAhfSJSIkpq5oMC4SzC2z3ubyoS
# IKKQ2cMlIzG86x5azs7xaU2UePEN/VFbCUWHKrbDwUGB
# SIG # End signature block
