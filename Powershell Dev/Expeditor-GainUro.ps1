. "$PSScriptRoot\Write-Log.ps1"


$gjv = Get-WmiObject -Class Win32_Product -ComputerName localhost -Filter "Name like 'Java%'" | Select -Expand Version 
$BrasUro = 'Permission java.net.SocketPermission "172.19.72.13", "connect,resolve";    ;'
$jcheck = Get-Childitem 'C:\Program Files (x86)\java\' |
          Where-Object {$_.PSIsContainer} |
          ForEach-Object {$_.name}
$gc6 = Get-content "C:\Program Files (x86)\java\$jcheck\lib\security\java.policy"
$javap = "C:\Program Files (x86)\java\$jcheck\lib\security\java.policy"


if ($precheck -eq $true)
{
Write-host "Java Installed"
}
else{close}

Write-host "$gjv - Current Java Version"


Add-Content -Path "c:\program files (x86)\java\$jcheck\lib\security\java.policy" -Value $BrasUro

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGGjUAtARccBNw6XVKX4ahpP8
# CYagggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQ5w9V9GKkwPhruhwNi+8RT9sTUzTAN
# BgkqhkiG9w0BAQEFAASCAQBLxksTwKCSMl3W7naDq1CSK0MdyoWcwwDbmdMRK5Ws
# bJhGopGrh9SRrhcMfqGHld+CgvB64ubrNnJv+7phdzhDHsXt6fQGONsg54tKXJRM
# l09OOxPh5eTVfHIGpj8h86iGXoDCgagFi5/8+u+4NJ9yB3fwrRs+2cUFxxGeA6ZY
# XUNSdzhzRgNTYUG95okICieLgeQJUuaTi1jbQqKjaS19PWIlqNsIch9ZRfHhTCZC
# VfNRdhILwcQUd7SG5D2aPcgyvSbSDnGn7ZAKg15Db4B5oOLcioSezdOe0ELz9DxA
# WDbEQ+trRwPX5OZH/1G2G6jWd/2bfLHRyLRPiC45ZI4I
# SIG # End signature block
