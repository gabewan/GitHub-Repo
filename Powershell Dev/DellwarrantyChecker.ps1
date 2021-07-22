function Get-DellWarranty {
    param(
        #Specifies the Dell Service Tag of the device we want to check
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true,
                   ValueFromPipeline = $true,
                   Position = 0)]
        [Alias('SerialNumber')]
        [String] $AssetTag,
        #Optionally pass a hostname for easier reporting on the results
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropergettyName = $true,
                   ValueFromPipeline = $false,
                   Position = 1)]
        [Alias('PSComputerName','ComputerName')]
        [String] $Hostname,
        #For multiple lookups in one request use input object, AssetTag and Hostname must be in the object
        [psobject] $InputObject,
        
        $APIKey = '849e027f476027a394edd656eaef4842',
        #If you have an API for sandbox testing use this switch
        [switch] $UseSandboxAPI
    )

    begin
    {
        # Small function to stop null or empty errors
        function ConvertTo-Date {
            Param($RawDate)
            if([string]::IsNullOrEmpty($RawDate)){
                return $RawDate
            }else{
                return [datetime]$RawDate
            }
        }
    }

    process
    {
        #Check if object is used and combine asset tags
        if($InputObject){
            $AssetTage = ($InputObject | Select-Object -ExpandProperty AssetTag) -join ','
        }

        #Dell Web Service URI
        if($UseSandboxAPI){
            [uri]$ServiceURI="https://sandbox.api.dell.com/support/assetinfo/v4/getassetwarranty/$($AssetTag)?apikey=$($APIKey)"
        }else{
            [uri]$ServiceURI="https://api.dell.com/support/assetinfo/v4/getassetwarranty/$($AssetTag)?apikey=$($APIKey)"
        }

        #Connect to web service proxy
        try
        {
            $WebRequestResult = (Invoke-WebRequest -Uri $ServiceURI -ErrorAction Stop).Content
        }
        catch
        {
            Write-Error "Unable to connect to Dell warranty API URI '$ServiceURI' - $_"
            return
        }

        #Build output list up
        $OutputHeaders = @(
            #User provided hostname
            'Hostname'
            #Asset header data
            'ServiceTag'
            'BUID'
            'CountryLookupCode'
            'CustomerNumber'
            'IsDuplicate'
            'ItemClassCode'
            'LocalChannel'
            'MachineDescription'
            'OrderNumber'
            'ParentServiceTag'
            'ShipDate'
            #Product data header
            'LOB'
            'LOBFriendlyName'
            'ProductFamily'
            'ProductId'
            'SystemDescription'
            #Entitlement data
            'EntitlementType'
            'ItemNumber'
            'ServiceLevelCode'
            'ServiceLevelDescription'
            'ServiceLevelGroup'
            'ServiceProvider'
            'StartDate'
            'EndDate'
        )

        try
        {
            if(-not $Hostname){
                $Hostname = 'Not Provided'
            }

            #Retrive Dell warranty information based on asset tag
            $DellInfoAll = ($WebRequestResult | ConvertFrom-Json).AssetWarrantyResponse
            
            #loop through results
            foreach($DellInfo IN $DellInfoAll){ 
                #If the Dell info has entitlements loop through each one else just return the single result
                if($DellInfo.AssetEntitlementData){
                    Foreach($Entitlement IN $DellInfo.AssetEntitlementData){
                        $Out = '' | Select-Object $OutputHeaders
                        $Out.Hostname = $Hostname

                        $Out.ServiceTag         = $DellInfo.AssetHeaderData.ServiceTag
                        $Out.BUID               = $DellInfo.AssetHeaderData.BUID
                        $Out.CountryLookupCode  = $DellInfo.AssetHeaderData.CountryLookupCode
                        $Out.CustomerNumber     = $DellInfo.AssetHeaderData.CustomerNumber
                        $Out.IsDuplicate        = $DellInfo.AssetHeaderData.IsDuplicate
                        $Out.ItemClassCode      = $DellInfo.AssetHeaderData.ItemClassCode
                        $Out.LocalChannel       = $DellInfo.AssetHeaderData.LocalChannel
                        $Out.MachineDescription = $DellInfo.AssetHeaderData.MachineDescription
                        $Out.OrderNumber        = $DellInfo.AssetHeaderData.OrderNumber
                        $Out.ParentServiceTag   = $DellInfo.AssetHeaderData.ParentServiceTag
                        $Out.ShipDate           = ConvertTo-Date $DellInfo.AssetHeaderData.ShipDate

                        $Out.LOB               = $DellInfo.ProductHeaderData.LOB
                        $Out.LOBFriendlyName   = $DellInfo.ProductHeaderData.LOBFriendlyName
                        $Out.ProductFamily     = $DellInfo.ProductHeaderData.ProductFamily
                        $Out.ProductId         = $DellInfo.ProductHeaderData.ProductId
                        $Out.SystemDescription = $DellInfo.ProductHeaderData.SystemDescription

                        $Out.EntitlementType         = $Entitlement.EntitlementType
                        $Out.ItemNumber              = $Entitlement.ItemNumber
                        $Out.ServiceLevelCode        = $Entitlement.ServiceLevelCode
                        $Out.ServiceLevelDescription = $Entitlement.ServiceLevelDescription
                        $Out.ServiceLevelGroup       = $Entitlement.ServiceLevelGroup
                        $Out.ServiceProvider         = $Entitlement.ServiceProvider
                        $Out.StartDate               = ConvertTo-Date $Entitlement.StartDate
                        $Out.EndDate                 = ConvertTo-Date $Entitlement.EndDate

                        $Out
                    }
                }else{
                    $Out = '' | Select-Object $OutputHeaders
                    $Out.Hostname = $Hostname

                    $Out.ServiceTag         = $DellInfo.AssetHeaderData.ServiceTag
                    $Out.BUID               = $DellInfo.AssetHeaderData.BUID
                    $Out.CountryLookupCode  = $DellInfo.AssetHeaderData.CountryLookupCode
                    $Out.CustomerNumber     = $DellInfo.AssetHeaderData.CustomerNumber
                    $Out.IsDuplicate        = $DellInfo.AssetHeaderData.IsDuplicate
                    $Out.ItemClassCode      = $DellInfo.AssetHeaderData.ItemClassCode
                    $Out.LocalChannel       = $DellInfo.AssetHeaderData.LocalChannel
                    $Out.MachineDescription = $DellInfo.AssetHeaderData.MachineDescription
                    $Out.OrderNumber        = $DellInfo.AssetHeaderData.OrderNumber
                    $Out.ParentServiceTag   = $DellInfo.AssetHeaderData.ParentServiceTag
                    $Out.ShipDate           = ConvertTo-Date $DellInfo.AssetHeaderData.ShipDate

                    $Out.LOB               = $DellInfo.ProductHeaderData.LOB
                    $Out.LOBFriendlyName   = $DellInfo.ProductHeaderData.LOBFriendlyName
                    $Out.ProductFamily     = $DellInfo.ProductHeaderData.ProductFamily
                    $Out.ProductId         = $DellInfo.ProductHeaderData.ProductId
                    $Out.SystemDescription = $DellInfo.ProductHeaderData.SystemDescription

                    $Out.EntitlementType         = $null
                    $Out.ItemNumber              = $null
                    $Out.ServiceLevelCode        = $null
                    $Out.ServiceLevelDescription = $null
                    $Out.ServiceLevelGroup       = $null
                    
                    $Out.StartDate               = $null
                    $Out.EndDate                 = $null

                    $Out
                }
            }
        }
        catch
        {
            Write-Error "Failed to obtain asset information for '$Hostname' using asset tag '$AssetTag' - $_"
            return
        }
    }

}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUcIg2kq7u2Ii87AEMlcb9ELc8
# W+agggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSFhbVAQ4wQoyAJbQagNL75AMYU/DAN
# BgkqhkiG9w0BAQEFAASCAQBAPiISW6ON3a3ou7sDDU+d+psQECvKHs6PDKoUnaKU
# xkDDRYshUnU/bsYC+s2p8UXsF3D9jYa0o8CSIGmnomdOh6gg45AZmCwZjAc+QAxp
# qasHAs3s08rrNiM9Pa59BPmREnN8o4vhYUljZIuEvHZEowC2rIU8cCRMoE2zkeOr
# M2zymsc2GBmTtNg75xwq7/9JPxvBbHhgqrVS7XtbNHlrB7WzoJ9hY11SLXZ7d8SL
# 0ppxPR84HH5JNpR8k8EhbtZ1fTVJf7y0NeVqJMykRXQRobBJn3asPXoLNBHS0l2L
# QMA31fuIwstLkpxm0hdFcZKzJrtXP8L80TWr15BmVodg
# SIG # End signature block
