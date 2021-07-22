. "$PSScriptRoot\Write-Log.ps1"


function expeditor-java {
$gjv = Get-WmiObject -Class Win32_Product -ComputerName localhost -Filter "Name like 'Java%'" | Select -Expand Version 
$BrasUro = 'Permission java.net.SocketPermission "172.26.42.11", "connect,resolve";'
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

}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUuXrUFA6XgupMjbJKqc5EpqWy
# V9egggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBTaiVi+qpBzB98zgyRabSF31roROzAN
# BgkqhkiG9w0BAQEFAASCAQAA8lCaY927itl4p91R7q0lXLvwiagaFDyBzRTS0A9i
# mp5aivrP6Rgzkqc6X0iFNBPSVW3LX4l3+YZWi9OoJETlxGJqQ5EK81KtxK7Akp8P
# kPsBd1wCXQgNmP/ZUHfk1q0Ahe4uheyszmII756T/htxqUBWSW8I3w2TcNBi+7EV
# opWOksMG4dYODv3N1Szn7yve4kq6Kw9v3/B/UpIVqs/Gbn5TTEsOLG04dDFZMSYi
# 3pCkLC/DZOYGB81hcq7adA/9eEl1m67phO93cMg5TalvahdYKHnsuDMaS6tz4cbC
# wVhofhPQZs4sZT1AMhy9bDnBOrKqczX83DG1vE3JtgvE
# SIG # End signature block
