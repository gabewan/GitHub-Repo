$Office2003 = Test-Path \\$object\HKLM:\software\microsoft\Office\11.0
$Office2007 = Test-path \\$object\HKLM:\software\microsoft\office\12.0
$office2010 = Test-Path \\$object\HKLM:\software\microsoft\office\14.0
$office2013 = Test-Path \\$object\HKLM:\SOFTWARE\Microsoft\Office\15.0
$office365 = Test-Path \\$object\HKLM:\SOFTWARE\Microsoft\office\16.0
$date = [DateTime]::Today.AddDays(-30)
$daterange = Get-ADComputer -Filter 'LastLogonDate -ge $date' -Properties LastLogonDate | Export-Csv "\\nghs.com\files\filesrv1\its\ITS Desktop Support\grlewis\ActiveAdComputers.csv" -Force 
$ch = "ComputerName"
$computers = Import-csv "\\nghs.com\files\filesrv1\its\ITS Desktop Support\grlewis\ActiveAdComputers.csv" | Select-Object $ch

foreach($object in $computers) {
$path = dir HKLM:\software\Microsoft\Office |%{
   if ($_.name -match '(\d+)\.') {
      if ([int]$matches[1] -gt $version) {
        $version = [int]$matches[1]
        }
    }
 }
 
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU9M452JBriJal0oWBMOH6NMtM
# OGKgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT06AEeHg2cJLmNM4S8enK1/RXM2DAN
# BgkqhkiG9w0BAQEFAASCAQArHwB+16bTuo18mcGxwikBRZfogcIjLT8564AAVTCo
# R4Rs42RKr58BTZwOtsNW+BBYx/o2zMszbNXERO5t6D8QrdA6jpXP8UbiZtpCbMrO
# JCYTyYs/yRswxLKChiuTTQUh/6u2ZRYpVPQcHnsWLiE3rxE4HgzZFjqZdTDBkYjr
# BX5blnoxH3X2B39n6fzNLYCOdpn4C5Zabr3k9h7RnSZ2j0j1amsMgvBwwsQQqjx1
# d8cXbFh7wwXZax1FoagvAfzPjW2R4KSwAnWEM+gInTH0do0hlMdhzOpBAVC4sB2p
# eb32uYLhYdBo7L/Xj/LfD5IhM380Skjo4gfuVSo74BbC
# SIG # End signature block
