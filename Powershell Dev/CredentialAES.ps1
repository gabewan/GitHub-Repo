$Key = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Powershell Logs\AES.key'
(get-credential).Password | ConvertFrom-SecureString -key (get-content '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Powershell Logs\AES.key') | set-content "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Powershell Logs\AES.txt"
$password = Get-Content '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Powershell Logs\AES.txt' | ConvertTo-SecureString -Key (Get-Content '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Profile\Powershell Logs\AES.key')
$credential = New-Object System.Management.Automation.PsCredential("grlewis",$password)
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzGbfxkBdCW+QltEqTHnwEEzL
# R42gggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRHNLZM2p+bYVJfqcW5c5sfYCqPXTAN
# BgkqhkiG9w0BAQEFAASCAQA/us5flBhbwWM+aVQdPzuK7ns3709qMzVrsAFy26Tj
# TTfp10bkTGphEeeZfyzea7vZWNlysfoGHF5k8Tb6JbEETb/4p+bpG/cW8jz/T2hR
# d0WIHoD/XGqglheC8O84k7/iApJreL1HGmKcuLB3a7J09VUoXTCv+W+GXfQsJTCQ
# t43XMQK7Qo3fRxZVb6nz/YXJUGj/jv76IjGKCRSqNttfS4mcwNqPWj2xvEP+nk/W
# 5MmNhocgtZgccycxy4ECGkIRtdHbA7GS7pNTByyO/m1/kWk50MBx95LJFygZ+g1C
# ZtXIY4Q37EWBeZNQWncLgpYpK78F4Kr1awrkaiO/4W0A
# SIG # End signature block
