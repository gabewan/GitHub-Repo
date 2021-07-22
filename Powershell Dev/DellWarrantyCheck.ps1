 Param(  
 
[Parameter(Mandatory=$true)]  
[String]$ServiceTag, 
[Parameter(Mandatory=$true)]  
[String]$ApiKey, 
[Parameter(Mandatory=$true)]  
[Bool]$Dev 
) 

$ApiKey = '849e027f476027a394edd656eaef4842'
#Build URL 
If ($Dev) 
{ 
$URL1 = "https://sandbox.api.dell.com/support/assetinfo/v4/getassetwarranty/$ServiceTag"  
} 
else 
{ 
$URL1 = "https://api.dell.com/support/assetinfo/v4/getassetwarranty/$ServiceTag"  
} 
$URL2 = "?apikey=$Apikey"  
$URL = $URL1 + $URL2  
 
# Get Data 
$Request = Invoke-RestMethod -URI $URL -Method GET -contenttype 'Application/xml'  
 
# Extract Warranty Info 
$Warranty=$Request.AssetWarrantyDTO.AssetWarrantyResponse.AssetWarrantyResponse.AssetEntitlementData.AssetEntitlement|where ServiceLevelDescription -NE 'Dell Digitial Delivery'  
 
# Read first entry if available 
If ($Warranty -is [Object])  
{  
    $SLA=$Warranty[0].ServiceLevelDescription  
    $EndDate=$Warranty[0].EndDate  
}  
else  
{  
$SLA='Expired'  
} 
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUw8WUH6y3asoXi+9aASDgJi0w
# ME6gggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRwH8Uz7iJPVqIONfL5nuSkvxLEAjAN
# BgkqhkiG9w0BAQEFAASCAQCJ8lYKS6jPKnsqot6+0GGePk98cUsw6dUB81TDh072
# 0KBnjlLSU+fJI8dvu7D7Ct/uB8wKNuWIej+jivQjjqybXwztiHg20IxaUx5f2UpC
# qAv02CeVwmRfcjYnLqNTV01yNoFXDd9AnRKhWfAS3C8y32X1m6eBZ2cx8qwbCOXj
# Dv6BfKA9hz8glGn+RFpnB9HB+/XWdcFLkyXrfV79ekVtFRZsOKj0wqUG0z5rhpkd
# iJ5cgFYYxbJ4AYEuOqX3n5INmS3UNdihd9XyjspXxjvV+eclsXNTdSu5CpGxd6Q5
# CHaYPRgohj3eP/Af4yPXyK4fcKFc7CREwbSFIp/qCDz5
# SIG # End signature block
