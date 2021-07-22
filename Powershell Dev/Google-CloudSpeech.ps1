#Common auth, URL and headers
$gauth = gcloud auth print-access-token
$headers = @{}
$headers.add("Authorization", "Bearer $gauth")
$target = "https://texttospeech.googleapis.com/v1/text:synthesize"

#Variables
$text = "Hey there! You're using plain text for this synthesis"
$languageCode = 'en'

$body = @{
    input = @{
        text = $text
    }
    voice = @{
        languageCode = $languageCode
    }
    audioConfig = @{
        audioEncoding = 'MP3'
    }
}

#Build JSON body for the request
$jbody = ConvertTo-Json ($body)

#Try conversion request
try{
    $response = Invoke-RestMethod -ContentType 'application/json' -headers $headers -Uri $target -Method Post -body $jbody
    #Extract the base64 encoded response
    $base64Audio = $response.audioContent

    #Produce output file
    $base64Audio | Out-File -FilePath "./google.txt" -Encoding ascii -Force
    $convertedFileName = 'GTTS-Plain-{0}.mpga' -f (get-date -f yyyy-MM-dd-hh-mm-ss)
    certutil -decode google.txt $convertedFileName
}catch {
    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmB/fIWQf68brK3XN4Qp53mIq
# B6CgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQnmXqGU0SWLhxKBw3K0H//jo+csTAN
# BgkqhkiG9w0BAQEFAASCAQClqienRLenBJhwcPOhBdE2XxQKhSBGkSqybB7hvCBq
# 6wJRlo+EKOx+e+0SG1Plvd5OWoQNvLbnyFnhKiVzaHo7LEXuhD/RgUIxHl0sW3kv
# u+M6d5jwAhFe9Goklnw+p8ZfrK+z+EcK0s7QcZo46T0us/OC1fUK2u5pRIWhwtXL
# ZUDJqA/sKG7OEBz2CyqTOoOD7h458VqF4H3KA37jtPnskc1jrOzkQergk1CxiCwQ
# 3Y90vIlZ5YkhteL5j5WnoK3HvH4MoCfhWzWSzim43eM0EmvsU8oAUKg6a5Tpxvvq
# MOo2tRWzaFXZa73d7npjZwn1UQYyvMKTRztjS4sluwtm
# SIG # End signature block
