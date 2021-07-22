#$logpath = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Powershell Logs"
$export = Get-ADComputer -Filter * -SearchBase "OU=Unassigned,OU=Workstations,DC=nghs,DC=com" | Select-Object -Property Name 
#$exps = import-csv "c:\users\grlewis\desktop\unassigned.csv"
$targetOULap = "OU=laptops,OU=workstations,DC=nghs,DC=com"
$targetOUDep = "OU=desktops,OU=workstations,DC=nghs,DC=com"

foreach($name in $export){
  
  Get-WmiObject -Class Win32_ComputerSystem -ComputerName "$name" | Select-Object -ExpandProperty PCSystemType 

   If($line -eq 1){
       # Move-ADObject $comp -TargetPath $targetOUDep -PassThru
        write-host $export.name
    }
    If($line -eq 2){
       # Move-ADObject $comp -TargetPath $targetOULap -PassThru
       write-host $export.name
    
    }
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2B1wsTgvCy1GLeWQPZ8SivF4
# ixWgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSs3K/F2Q79s60rKhwF++v+cFzqsTAN
# BgkqhkiG9w0BAQEFAASCAQADuLnLNE9YydY/uf1eF0iikzgsXO3pCVLy1+HRNcUv
# TdVjN9gh64zwqYwFY9HvYmCmhrzOcZbQnJKWXfVjz2laJnnM/KEtSKX38RPs73oE
# kjxCD28eg/gbd3k7Ez0ZGRFNlvKaoP0BbixFqO/JXoPu6S6qzY2Tl2Gli6VauRjV
# JZ9R5V5pYxqMbWgziEOjEYMlpG7jyg/iBB938beTyXd+hun/+G8aQtu3PZX4bs+y
# LlUtgIZzBj6GFvnrY0+VkOdrQ8TMV1M7fbTNqe/MD/4A6uuN8fJo7HTOugoh4Nge
# pWE58311+aojyhWQLLQWXjT1eUpnf5NcKMZdIFHq+KCZ
# SIG # End signature block
