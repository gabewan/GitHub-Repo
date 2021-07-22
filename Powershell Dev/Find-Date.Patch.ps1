function Find-Day {

param(
    [int]$Year, 
    [int]$Month, 
    [DayOfWeek]$Day, 
    [int]$Occurrence
    )

if ($Occurrence -le 0 -or $Occurrence-gt 5)
{
	throw (New-Object -TypeName Exception -ArgumentList "Occurrence is invalid")
}
[DateTime]$firstDayOfMonth = (New-Object -TypeName DateTime -ArgumentList $year,$month,1)
$daysneeded = [int]$Day - [int]$firstDayOfMonth.DayOfWeek
if ($daysneeded -lt 0) {
	$daysneeded = $daysneeded + 7 
}
$resultedDay = ($daysneeded + 1) + (7 * ($Occurrence  - 1))
if ($resultedDay -gt ($firstDayOfMonth.AddMonths(1) - $firstDayOfMonth).Days)
{
	throw (New-Object -TypeName Exception -ArgumentList $String.Format("No {0} Occurrence of {1} in the required month",$Occurrence,$Day.ToString()))
}
return $resultedDay
}

#Find-Day -Month (Get-Date).Month -Day Tuesday -Year (Get-Date).Year -Occurrence 2
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXKF7TdVCGOySVmLuKsHDh+Br
# +YqgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRttXfHAYF5H8J3WfISczOPVK1+MTAN
# BgkqhkiG9w0BAQEFAASCAQCpzBbq6b+KOqhnhMeqJH8ObXhm3ILVqbAcQR5DwM32
# 21W8S9Pvxq2+OPK1ptTvX58WYr5Z5ukMjhoxagf01DvM6aCXnnNbL4u/SdzuPPQY
# PPSTM0Pj+p8MNYcf3o9fSB5VciYUgs8YAnT5a+OCOZgxSd3p+adCtuUpm7iqBZtG
# NgoCFKpM+ZcCsgSuncl2lA7MWP9BxDsp7EITYZAf+1Lot0G/B95GM1KmsNfzBmgw
# VKGLC9Yaf3vviNQZ+zk8AEX4KM8kv0SaF7Np3ohZXzS2vKzsLOznIXr1LwMLpI2G
# 1mQYwyS7c4amBuMCQRYqXR6+PCwS1P2W20FG/MMbfz0n
# SIG # End signature block
