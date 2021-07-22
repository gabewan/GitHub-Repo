$unassouexport = Get-ADComputer -Filter * -SearchBase "OU=Unassigned,OU=Workstations,DC=nghs,DC=com" | Select-Object -Property SamAccountName | Sort-Object -Property SamAccountName | export-csv \\hqsbvnxfile1\its\data\desktopsupport\grlewis\scripts\AD.Add\unassigned.csv -Force
$ch = "ComputerName"
$computers1 = Get-Content "\\hqsbvnxfile1\its\data\desktopsupport\grlewis\scripts\AD.Add\unassigned.csv"
$computers = Import-csv "\\hqsbvnxfile1\its\data\desktopsupport\grlewis\scripts\AD.Add\unassigned.csv"
$targetOULap = "OU=laptops,OU=workstations,DC=nghs,DC=com"
$targetOUDep = "OU=desktops,OU=workstations,DC=nghs,DC=com"

foreach ($object in $computers) {
$cd = Get-AdComputer $object.ComputerName
$dn = $cd.distinguishedname
$model = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $_ | Select-Object -ExpandProperty PCSystemType

Model 1 - Desktop
Model 2 - Laptop
$name = $object.distinguishedname
if ($model -eq 1) {
   Move-ADObject -Identity $dn -TargetPath $targetOUDep -PassThru
    }
If ($model -eq 2){
    Move-ADObject -Identity $dn -TargetPath $targetOULap -PassThru
    }
}
 
 


# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUNpHa7acTn6l9GA9wGM8Y5QMR
# s+agggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT65tltUSevWw/NlbFlPE485Z7VvTAN
# BgkqhkiG9w0BAQEFAASCAQAyZ8Xo/jaKpsGSV7LbiIFDTOhExO7lOAehRuCjFVDL
# 72/DV9MJQm0fPY1lrkVxC3uEbdvPp8YJihi2pPdcUVyT1Efoy80V/Ope7QjfywX0
# 4vRwA3i16X3WeP/MncG0e583lI6V7FnlQgf1kJE2LrUQyj/Om190N1zkZVwxqh0+
# jOR+558aoTQopm3db1Welpb8lbZS1Aj6ASsFzxyJM9yQNpjfTGNsn6k2/eYzINoe
# HavfdtNrSbKM49/XekLUMvyUmv8xLp8EXbnqZevXt9FUM4MRUhMjaCf1bhhDvw2o
# Xn6aNoGGr2pwciSolvXdoraqifkuszybh8kLQVS64hK/
# SIG # End signature block
