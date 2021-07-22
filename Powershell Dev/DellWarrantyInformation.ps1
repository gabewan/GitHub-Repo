[CmdletBinding()]
param(
    [parameter(Mandatory=$false)]
    [string]$ServiceTag,
    [parameter(Mandatory=$false)]
    [string]$ComputerName,
    [parameter(Mandatory=$false)]
    [switch]$ExportCSV,
    [parameter(Mandatory=$false)]
    [string]$ImportFile
)
 
function Get-DellWarrantyInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [alias("SerialNumber")]
        [string[]]$GetServiceTag
    )
    Process {
        if ($ServiceTag) {
            if ($ServiceTag.Length -ne 7) {
                Write-Warning "The specified service tag wasn't entered correctly"
                break
            }
        }
    $WebProxy = New-WebServiceProxy -Uri "http://xserv.dell.com/services/AssetService.asmx?WSDL" -UseDefaultCredential
    $WebProxy.Url = "http://xserv.dell.com/services/AssetService.asmx"
    $WarrantyInformation = $WebProxy.GetAssetInformation(([guid]::NewGuid()).Guid, "Dell Warranty", $GetServiceTag)
    $WarrantyInformation | Select-Object -ExpandProperty Entitlements
    return $WarrantyInformation
    }
}
 
if ($ServiceTag) {
    if (($ComputerName) -OR ($ExportCSV) -OR ($ImportFile)) {
        Write-Warning "You can't combine the ServiceTag parameter with other parameters"
    }
    else {
        $WarrantyObject = Get-DellWarrantyInfo -GetServiceTag $ServiceTag | Select-Object @{Label="ServiceTag";Expression={$ServiceTag}},@{label="StartDate";Expression={$_.StartDate.ToString().SubString(0,10)}},@{label="EndDate";Expression={$_.EndDate.ToString().SubString(0,10)}},DaysLeft,EntitlementType
        $WarrantyObject[0,1] #Remove [0,1] to get everything
    }
}
 
if ($ComputerName) {
    if (($ServiceTag) -OR ($ExportCSV) -OR ($ImportFile)) {
        Write-Warning "You can't combine the ComputerName parameter with other parameters"
    }
    else {
        [string]$SerialNumber = (Get-WmiObject -Namespace "root\cimv2" -Class Win32_SystemEnclosure -ComputerName $ComputerName).SerialNumber
        $WarrantyObject = Get-DellWarrantyInfo -GetServiceTag $SerialNumber | Select-Object @{Label="ComputerName";Expression={$ComputerName}},@{label="StartDate";Expression={$_.StartDate.ToString().SubString(0,10)}},@{label="EndDate";Expression={$_.EndDate.ToString().SubString(0,10)}},DaysLeft,EntitlementType
        $WarrantyObject[0,1] #Remove [0,1] to get everything
    }
}
 
if (($ImportFile)) {
    if (($ServiceTag) -OR ($ComputerName)) {
        Write-Warning "You can't combine the ImportFile parameter with ServiceTag or ComputerName"
    }
    else {
        if (!(Test-Path -Path $ImportFile)) {
            Write-Warning "File not found"
            break
        }
        elseif (!$ImportFile.EndsWith(".txt")) {
            Write-Warning "You can only specify a .txt file"
            break
        }
        else {
            if (!$ExportCSV) {
                $GetServiceTagFromFile = Get-Content -Path $ImportFile
                foreach ($ServiceTags in $GetServiceTagFromFile) {
                    $WarrantyObject = Get-DellWarrantyInfo -GetServiceTag $ServiceTags | Select-Object @{Label="ServiceTag";Expression={$ServiceTags}},@{label="StartDate";Expression={$_.StartDate.ToString().SubString(0,10)}},@{label="EndDate";Expression={$_.EndDate.ToString().SubString(0,10)}},DaysLeft,EntitlementType
                    $WarrantyObject[0,1] #Remove [0,1] to get everything
                }
            }
            elseif ($ExportCSV) {
                $GetServiceTagFromFile = Get-Content -Path $ImportFile
                $ExportPath = Read-Host "Enter a path to export the results"
                $ExportFileName = "WarrantyInfo.csv"
                foreach ($ServiceTags in $GetServiceTagFromFile) {
                    $WarrantyObject = Get-DellWarrantyInfo -GetServiceTag $ServiceTags | Select-Object @{Label="ServiceTag";Expression={$ServiceTags}},@{label="StartDate";Expression={$_.StartDate.ToString().SubString(0,10)}},@{label="EndDate";Expression={$_.EndDate.ToString().SubString(0,10)}},DaysLeft,EntitlementType
                    if (!(Test-Path -Path $ExportPath)) {
                        Write-Warning "Path not found"
                        break
                    }
                    else {
                        $FullExportPath = Join-Path -Path $ExportPath -ChildPath $ExportFileName
                        $WarrantyObject[0,1] | Export-Csv -Path $FullExportPath -Delimiter "," -NoTypeInformation -Append #Remove [0,1] to get everything
                    }
                }
            (Get-Content $FullExportPath) | ForEach-Object { $_ -replace '"', "" } | Out-File $FullExportPath
            Write-Output "File successfully exported to $FullExportPath"
            }
        }
    }
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4cybG6UWlkW5zRLv1X+oDUh1
# iaCgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRC/y8AIDzUBqyx4yNK4dlhFQfVZDAN
# BgkqhkiG9w0BAQEFAASCAQCLO11CP47a18w3Ze9W7e1awGxa8Pz4eZoOJX93IHZN
# n6sWFo9sMPX62vCD1lXFdWD+E9pNdvkUjOaXvyF06LYcMuKW0O9KANMPYrbqyeNP
# qc/aZhG8wP3cM+bHddkZeCkA7SGPWN1io2qc9yhgzQuVBVUcvPQfOZRQD7MZigUM
# FRPgh0R7w1S2hXDeAef+AZ31NErN4NhD/Vp3tByHR+Uqbd7hGr+HoLZUPKmWL6+e
# wb2FaVnJklqrImouSRODslYb2g/b+HQABnGaya9KiAS/9xxRRPwFrf3SUz43Ssr7
# Z+SU8+EbdIXFxe+GBFpuwoOg3mA7Zcsr0BC5yjhDbq9l
# SIG # End signature block
