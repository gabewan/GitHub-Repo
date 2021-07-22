$username = Read-host "Enter Username"
$members = ([ADSISEARCHER]"samaccountname=$username").Findone().Properties.memberof | Out-File "\\hqsbvnxfile1\its\DATA\GLewis\ScriptLogs\AdMemberships.txt" -Force
#$list = $members | Export-Csv "\\hqsbvnxfile1\its\DATA\GLewis\ScriptLogs\AdMemberships.csv" -Force
$pat = @("365")
$list2 = Get-content -Path "\\hqsbvnxfile1\its\data\glewis\ScriptLogs\AdMemberships.txt" | Select-String -Pattern $pat -SimpleMatch | set-content -Path "\\hqsbvnxfile1\its\data\glewis\scriptlogs\365membergroup.txt"
$list3 = get-content -path "\\hqsbvnxfile1\its\data\glewis\scriptlogs\365membergroup.txt"

if ($list3 -eq "CN=Office 365 Users,OU=AzureAD,OU=Groups,DC=nghs,DC=com"){
Write-Host "User is active in the 365 Active Directory AD OU"
}
else {Write-host "User is not in the Office 365 Active Directory OU"}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpHMR+XG0odhiHtYKTVcabBmb
# xG6gggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRL+cEoFvwFLSc/ntotEXoQtfFN0jAN
# BgkqhkiG9w0BAQEFAASCAQBSbwLIjqtwFMKqZD/Ys85Mt8al07x36f+5EBCoFmZJ
# 6pqp/dYe966zUwQqcSNr7k6NZ0UF8+10POc6N0WqgwzSM772Y3U48ffjFAtbRFcw
# 3jOYCCZv7Cn7tSzxDTdzyNx9MQW83ejXYvC2ST7hHZWb3FGMQDUZIoyUHhBv63v8
# 8QchaXe1kNIfByK0+kM0tiXBXIDSJxWGxT0rgKuth+8T1XwFG+RaBfWeu5KGdTsp
# eZeYNfzwcjd71ijmD9ADrtEj8zWVWObk/8OHJZQZrHbrqj2O7vWo7aTqaRlK0eiJ
# vav1WHhW9tlbwBXBO1jR3LC8NqbgcaWgAgJ0YtxTK+XL
# SIG # End signature block
