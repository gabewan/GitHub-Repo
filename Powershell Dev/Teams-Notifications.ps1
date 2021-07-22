Clear-Host
Import-Module PSTeams 
$TeamsID = 'https://outlook.office.com/webhook/a5c7c95a....'
$Color = [System.Drawing.Color]::Chocolate
$Button1 = New-TeamsButton -Name 'Visit English Evotec Website' -Link "https://evotec.xyz"
$Button2 = New-TeamsButton -Name 'Visit Polish Evotec Website' -Link "https://evotec.pl"
$Fact1 = New-TeamsFact -Name 'Bold' -Value '**Special Bold value**'
$Fact2 = New-TeamsFact -Name 'Italic and Bold' -Value '***Italic and Bold value***'
$Fact3 = New-TeamsFact -Name 'Italic' -Value 'Date with italic *2010-10-10*'
$Fact4 = New-TeamsFact -Name 'Link example' -Value "[Microsoft](https://www.microsoft.com)"
$Fact5 = New-TeamsFact -Name 'Other link example' -Value "[Evotec](https://evotec.xyz) and some **bold** text"
$Fact6 = New-TeamsFact -Name 'This is how list looks like' -Value "
* hello
    * 2010-10-10
* test
    * another
* test
* hello"
$Fact7 = New-TeamsFact -Name 'This is strike through example' -Value "<strike> This is strike-through </strike>"
$Fact8 = New-TeamsFact -Name 'List example with nested list' -Value "
- One value
- Another value
    - Third value
        - Fourth value
"
$Fact9 = New-TeamsFact -Name 'List example with a twist' -Value "
1. First ordered list item
2. Another item
* Unordered sub-list.
1. Actual numbers don't matter, just that it's a number
    1. Ordered sub-list
    2. Another entry
4. And another item.
"
$Fact10 = New-TeamsFact -Name 'Code highlight' -Value "This is ``showing code highlight`` "
$Fact11 = New-TeamsFact -Name '' -Value "
### As you see I've not added Name at all for this one and it merges a bit with Fact 10
This is going to add horizontal line below. While this line is highlighed.
---
And a block quote
> Block quote
# H1
## H2
### H3
#### H4
##### H5
###### H6
"
$Section1 = New-TeamsSection `
    -ActivityTitle "**Przemyslaw Klys**" `
    -ActivitySubtitle "@przemyslawklys - 9/12/2016 at 5:33pm" `
    -ActivityImageLink "https://pbs.twimg.com/profile_images/1017741651584970753/hGsbJo-o_400x400.jpg" `
    -ActivityText "Climate change explained in comic book form by xkcd xkcd.com/1732" `
    -Buttons $Button1, $Button2 `
    -ActivityDetails $Fact1, $Fact2
$Section2 = New-TeamsSection `
    -ActivityTitle "**Przemyslaw Klys**" `
    -ActivitySubtitle "@przemyslawklys - 9/12/2016 at 5:33pm" `
    -ActivityImageLink "https://pbs.twimg.com/profile_images/1017741651584970753/hGsbJo-o_400x400.jpg" `
    -ActivityText "Climate change explained in comic book form by xkcd xkcd.com/1732" `
    -Buttons $Button1 `
    -ActivityDetails $Fact3, $Fact4, $Fact5, $Fact6, $Fact7, $Fact8, $Fact9, $Fact10, $Fact11
$Section3 = New-TeamsSection `
    -ActivityTitle "**Przemyslaw Klys**" `
    -ActivitySubtitle "@przemyslawklys - 9/12/2016 at 5:33pm" `
    -ActivityImage Add `
    -ActivityText "Climate change explained in comic book form by xkcd xkcd.com/1732" `
    -Buttons $Button1 `
    -ActivityDetails $Fact3, $Fact4, $Fact5, $Fact6, $Fact7, $Fact8, $Fact9, $Fact10, $Fact11
Send-TeamsMessage `
    -URI $TeamsID `
    -MessageTitle 'Message Title' `
    -MessageText 'This is text' `
    -Color Chocolate `
    -Sections $Section2, $Section1 
Send-TeamsMessage `
    -URI $TeamsID `
    -MessageTitle 'Message Title' `
    -MessageText 'This is text' `
    -Color Chocolate `
    -Sections $Section3
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUPmhqVo7FjboI45chppAbuXRH
# p6ugggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSrRzQ8CVfSJnjZ/DepnMI7+KTB/DAN
# BgkqhkiG9w0BAQEFAASCAQA1d964vmVNljZyoohIxkUdDUQnjJ+KGLxRe0xNMzwJ
# NoshbMYtjSFHNmOQiWIp4mfNQ3gTKn+A2Yyk4Wpkij1BvLushO2VPH0+qUA0A6/Q
# PrWZSYgCqsg8le2nERW6D/GPACSIurx7w4A4AA5KOPlpMnApjEoed3kOEERaAnDk
# 7kic/YqtThVkwXJ3JLDlHLQG1wENq8wVZE5tYVdRf+vzNOxeQDg0voWOJv5NXOCy
# S0kh7Nxd9LWotJ4xV6Z/VHG/th7pTCm5vRUPAr9k5ESsRK8h0xxaBhBOFWue/CMp
# N9yR+S+TwHazTJiuQQxpC659ugo1YvqgzpHOBP8eRxzB
# SIG # End signature block
