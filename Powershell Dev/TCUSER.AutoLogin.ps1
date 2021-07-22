function AutoLoginScript
{ 
$RgPh = 'HKLM:\software\microsoft\Windows NT\CurrentVersion\Winlogon'
$AAd = "AutoAdminLogon"
$DUN = "DefaultUsername"
$DP = "DefaultPassword"
$DDN = "DefaultDomainName"
$FALogon = "ForceAutoLogon"
$Shell = "Shell"
$1 = "1"
$0 = "0"
$DW = "DWORD"
$STR = "STRING"
$DUNW = Read-host "Enter Barcode:" -ForegroundColor Yellow

Write-Host "Select an option or type" -NoNewline
Write-Host " [quit] " -ForegroundColor Yellow -NoNewline
Write-Host "to exit: " -NoNewline
$input = Read-Host


New-ItemProperty -path $RgPh -Name $AAd -Value $1 -PropertyType $DW -Force | Out-Null
New-ItemProperty -path $RgPh -Name $DUN -Value $ -PropertyType $DW -Force | Out-Null
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUNQhf1cXfb6Ujgr+eTiV80ihE
# 06KgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRW5GzTOYnQE8A+DUWhk4bLPI9VmjAN
# BgkqhkiG9w0BAQEFAASCAQApryZFNG1lQfgl1jKPVqNgq0eHn5hS3yoMA07w6S3k
# DBXpfQ8leKHRRNjqNHVlnyqzv7xfSBgfCkCRabDsm2Zuhnk2P4BVtkB7OOR1EoxD
# w6bR8BEOTGi6XzV6lydq0Q/7lrO9ivuw4jI67sKQh2tj94QlTj5jC6RWDy2S4xOH
# J6CUk3qsJ8vxTaH+62c+39jYwgRyeHz0kdIxiK4AZLD0yF+URnj3hiV1zT8be/04
# O5szEnJfqYzbDTKZbYVGLQsIoxRzBo0vf7r+9D8mASW/bBdVkMO2HwmASHeCWE+o
# rgqk9mK1ZnsA68OWXGRhzyVpLYIuG/BpxRdxkE/+2Eiz
# SIG # End signature block
