$reportpath = "C:\Scripts\lgr.csv"
$domainname = 'dc=nghs,dc=com'

Import-Module ActiveDirectory

$computers=@(Get-ADComputer -SearchBase $domainname -Filter '*' | Select-Object -ExpandProperty Name)
$array = @()

foreach ($computername in $computers) {

Trap {
write-warning "Error Trapped for $computername"
write-warning $_.Exception.Message
Continue
}

if (Test-Connection $computername -erroraction silentlyContinue ) {
$array += get-wmiobject Win32_ComputerSystem -computername $computername |
select -property Name,Username,Manufacturer,Model,SystemType
}
else {
"***** " + $computername + " is down. *****"
}

}

$array | Export-CSV "$reportpath" -Force
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUb5bRBDZZWyiU96fAENOsTeGJ
# bCWgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSPz8XSaq1dqFuN7kc7702+14qa0TAN
# BgkqhkiG9w0BAQEFAASCAQAa2UrQqcxUnvNS/dkuXMxdmc+kH/XOcwT5KBpapmyp
# Z5uDom/HllSxgaHOvVNFnlAMO+nfXyCps16t+4zBzQ5GZldMfoVPm++W9bI3o+nP
# cgTK5E7+Jt5Pp2VuMIAevQBjvaIukXCJylsVEA0JmNCVDv4rnGTGYuo4jxA3dRfg
# jp+JZQsBOgoUwxQm8W5VOD9JXjyU35pgDAYSng4JqiS1bonLbbLROtiBvVbrC/L1
# frExvVYfaC6uuu81pajMqZ3rz1oiB/WB2VT2f4r08Wf2L6sj2JstUbRNFdlqG32X
# ZY6m6jm4XmLeV7WohMj1xekMi6/P/6U4EgrdMo3jqd6V
# SIG # End signature block
