Function Global:Get-DWC {
Param([String]$ServiceTag)
$APIKey = "849e027f476027a394edd656eaef4842"
$DellURL = "https://sandbox.api.dell.com/support/v2/assetinfo/warranty/tags.xml?svctags=$ServiceTag&apikey=$APIKey"
$XML = New-Object System.Xml.XmlDocument
$XML.Load($DellURL)
$XML.GetAssetWarrantyResponse.GetAssetWarrantyResult.Response.DellAsset
}

$tags = get-content 'C:\Users\grlewis\Documents\PS Scripts\profilefunctions\Calls\Get.DWC.Import.txt' -force
 Foreach ($tag in $tags)
 {#format-table -wrap -force
 Get-DWC -ServiceTag $tag | format-table -wrap -force
 }


# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwkEX+WJZQ1H2E6o48rH7n0zk
# oNGgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBR3r50JVBFRpnEbzW4wTP0cw3RKnzAN
# BgkqhkiG9w0BAQEFAASCAQA2E1nkV9O9l1FkCI6fKgZaquIuvLu8FyLR0cK89xQK
# VCBRXQPFfzmqBEuxSHEyF8NfwEHnEtLkvyqGKtXAd1vA4LYDJkaYIRnBTJBU6P7j
# hjF5Dx9o2bcX0SIjFWMPWhyvK1ahWDYGlgbk9Qzu9mnq0g6GtpLE3GPom8L21hxM
# eyBotIyQYUafPzc4GIUwrKZxw/i/kxrZ8vlSS0nexFOxTzo/Vc2+TPnV7PcvXJkk
# GLQl7IgogXk70deY3UlEZAwMmzQgNbgRMmzzE467PSDrl20UMr5EblPMXkJmbHCf
# PQigZcjQM+du4B8ToGpkWtXmg4Qg5oQulnlZONckbNvI
# SIG # End signature block
