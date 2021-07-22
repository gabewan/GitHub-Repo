$names = Get-content "c:\temp\text.txt"
$rp1 = "HKLM:\Software\WOW6432Node\SSOProvider\VDI\XenApp"
$rp2 = "HKLM:\Software\WOW6432Node\SSOProvider\VDI\XenApp\"
$key = "DisableLocking"
$value = 1
$tp = test-path "c:\Program Files\CCSI\800"

foreach ($name in $names){
        New-item -Path $rp1 -name $key -Force
        New-ItemProperty -Path $rp2 -Name $key -Value $value -PropertyType DWORD -Force 
        write-host "$name reg key added" 
        #start-sleep -Seconds 3
        stop-process -name svdsp -ErrorAction SilentlyContinue
  }

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUQlfhnmy3acRPHLA+kfCL3u8E
# Z4ugggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQ4egyJ2Ec4uBokhybK/nWMD7KGIzAN
# BgkqhkiG9w0BAQEFAASCAQCjVHTzvqv796d82H9nQ0fZmDWypXVuyN30U3WSA7h1
# T0yzhCTTIrG5UJ6QgejF/fVxOIZjOfH7renm5JaCKjUdvLLwBaf2OUNHFB1DLU5f
# iIGIkdFJ1dEfQaS8c7fZsq8FmmOjI1Cx1a5tognZWV1IUUKUamNoabgdh++lJ2Ef
# zsNMyejE8XcxKMQ/VJfbUxWF3jo1V7iRZ8PushS9O9mDiTb8lMmUa0bDU1kU+25a
# psDf69zUs7zagtueYqJRBX+YV7XwoRK+gvb+9RKA4z1axMke1FvhQpugkhN4uRxC
# pHtszopbRsbtHIGRJVqzOSNuWDuJUiij766UWNggU/KS
# SIG # End signature block
