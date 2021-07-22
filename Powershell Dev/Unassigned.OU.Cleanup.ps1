#Only enable Export when this needs to sync with AD!
#$export = Get-ADComputer -Filter * -SearchBase "OU=Unassigned,OU=Workstations,DC=nghs,DC=com" | Select-Object -Property SamAccountName | Sort-Object -Property SamAccountName | export-csv \\hqsbvnxfile1\its\data\desktopsupport\grlewis\scripts\AD.Add\unassigned.csv -Force
$ch = "ComputerName"
$computers = Import-csv "\\hqsbvnxfile1\its\data\desktopsupport\grlewis\scripts\AD.Add\unassigned.csv" | Select-Object $ch
$targetOULap = "OU=laptops,OU=workstations,DC=nghs,DC=com"
$targetOUDep = "OU=desktops,OU=workstations,DC=nghs,DC=com"

foreach($object in $computers) {
$cd = Get-AdComputer $object.ComputerName
$dn = $cd.distinguishedname
$model = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $object.("Computername") | Select-Object -ExpandProperty PCSystemType
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUU6N1vr2mhQUyDrv9xthzWHVG
# 4oigggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT09Mg4uAjUgMG0PPdqKgmq5q22ZzAN
# BgkqhkiG9w0BAQEFAASCAQCMaYTZnPJVvMfL+jlXr7IDuAbHRY2OVSKzgLPvh7w4
# L/xq5g+phfX8kxhIMs8UVMcD68hU/mXRtCleGQ4lVa/yG6CzX1tKI94MnGwX8+qq
# BxF2reHpRFkvklceiqKRiXBgA+KZhoRdC2dc5Ut5BJnQZqu38WGvb7oJFDVfBfup
# Uh9hGGLwC9pEb1caIaYnFORDLmIjSktyTgCI0BjvlQbRZGLs5gybbuaNNxI6C+l8
# 8CO2jgYSyTsl+VhB2kivuxGeNmqYr47D9NcqRf+My6AD/D0MmR30K3mE46/GMyth
# SrYzp1iKFNZ7+Aeeu/Yfc3+SN5mdCzzrzpKiC9umVvTG
# SIG # End signature block
