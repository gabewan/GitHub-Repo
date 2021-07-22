cls
$computers = "c:\users\grlewis\documents\new 1.csv"
foreach ($computer in $computers)
{
if (Test-Connection -count 1 -computer $computer.Name -quiet){
Write-Host "Updating system" $computer.Name "....." -ForegroundColor Green
Set-Service –Name remoteregistry –Computer $computer.Name -StartupType Automatic
Get-Service remoteregistry -ComputerName $computer.Name | start-service
}
else
{
Write-Host "System Offline " $computer.Name "....." -ForegroundColor Red
echo $computer.Name >> C:\scripts\Inventory\offlineRemoteRegStartup.txt}
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0symbNeTGCmfTGC9JgzHnnv5
# I5GgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSUSlGDTn+t6BaUhdAMIQw8bZLyPzAN
# BgkqhkiG9w0BAQEFAASCAQBEPYFi8B9hK+PmiJsil3XJoQSiywCvjshe3t5Cjraj
# Ja0Dz2H/Aws7leDNCYcyuDdg9Z+fzEqxqtjRKmjs+XgZbjF4TxNJmXP9MN9IbKyE
# 13TeKdmNhtjNr5UCnL9OhjhNdvxSDTYfHfB29QVZSgvhx4QLZ+JZnEnsHVlPPyq2
# cKXjX33iJv73X9aQ2R4Qm1ZWc8bQikiTS9ZUkyVgGhf5ngDKkuwTUYu8XrWuSIek
# /4xHm7iB8vSMaQ0vZk+miOMPbhKGUhPlJ9E+hiz9Kkc9BQN1D0e/xIvbnHN1WURH
# /xWvCUKwWeGSOIBIxwTaDDiAhxyaDn3NB4hqfaEm2RwP
# SIG # End signature block
