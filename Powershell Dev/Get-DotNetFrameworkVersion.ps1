<#
    Script Name	: Get-NetFrameworkVersion.ps1
    Description	: This script reports the various .NET Framework versions installed on the local or a remote computer.
    Author		: Martin Schvartzman
    Last Update	: July-2018
    Keywords	: NETFX, Registry
    Reference   : https://msdn.microsoft.com/en-us/library/hh925568
#>

param(
    [string]$ComputerName = "404pacpc018"
)

$dotNetRegistry = 'SOFTWARE\Microsoft\NET Framework Setup\NDP'
$dotNet4Registry = 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
$dotNet4Builds = @{
    '30319'  = @{ Version = [System.Version]'4.0'                                                     }
    '378389' = @{ Version = [System.Version]'4.5'                                                     }
    '378675' = @{ Version = [System.Version]'4.5.1'   ; Comment = '(8.1/2012R2)'                      }
    '378758' = @{ Version = [System.Version]'4.5.1'   ; Comment = '(8/7 SP1/Vista SP2)'               }
    '379893' = @{ Version = [System.Version]'4.5.2'                                                   }
    '380042' = @{ Version = [System.Version]'4.5'     ; Comment = 'and later with KB3168275 rollup'   }
    '393295' = @{ Version = [System.Version]'4.6'     ; Comment = '(Windows 10)'                      }
    '393297' = @{ Version = [System.Version]'4.6'     ; Comment = '(NON Windows 10)'                  }
    '394254' = @{ Version = [System.Version]'4.6.1'   ; Comment = '(Windows 10)'                      }
    '394271' = @{ Version = [System.Version]'4.6.1'   ; Comment = '(NON Windows 10)'                  }
    '394802' = @{ Version = [System.Version]'4.6.2'   ; Comment = '(Windows 10 1607)'                 }
    '394806' = @{ Version = [System.Version]'4.6.2'   ; Comment = '(NON Windows 10)'                  }
    '460798' = @{ Version = [System.Version]'4.7'     ; Comment = '(Windows 10 1703)'                 }
    '460805' = @{ Version = [System.Version]'4.7'     ; Comment = '(NON Windows 10)'                  }
    '461308' = @{ Version = [System.Version]'4.7.1'   ; Comment = '(Windows 10 1709)'                 }
    '461310' = @{ Version = [System.Version]'4.7.1'   ; Comment = '(NON Windows 10)'                  }
    '461808' = @{ Version = [System.Version]'4.7.2'   ; Comment = '(Windows 10 1803)'                 }
    '461814' = @{ Version = [System.Version]'4.7.2'   ; Comment = '(NON Windows 10)'                  }
}

foreach($computer in $ComputerName) {
    if($regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $computer)) {
        if ($netRegKey = $regKey.OpenSubKey("$dotNetRegistry")) {
            foreach ($versionKeyName in $netRegKey.GetSubKeyNames()) {
                if ($versionKeyName -match '^v[123]') {
                    $versionKey = $netRegKey.OpenSubKey($versionKeyName)
                    $version = [System.Version]($versionKey.GetValue('Version', ''))
                    New-Object -TypeName PSObject -Property ([ordered]@{
                            ComputerName = $computer
                            Build        = $version.Build
                            Version      = $version
                            Comment      = ''
                        })
                }
            }
        }

        if ($net4RegKey = $regKey.OpenSubKey("$dotNet4Registry")) {
            if(-not ($net4Release = $net4RegKey.GetValue('Release'))) {
                $net4Release = 30319
            }
            New-Object -TypeName PSObject -Property ([ordered]@{
                    ComputerName = $Computer
                    Build        = $net4Release
                    Version      = $dotNet4Builds["$net4Release"].Version
                    Comment      = $dotNet4Builds["$net4Release"].Comment
                })
        }
    }
}

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUuH7Y5htMkC/C4+3FKeXs5LLo
# SVegggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBScwX5zkIDCxsUCHJ37z1vlxXVrUjAN
# BgkqhkiG9w0BAQEFAASCAQA5fdODqISTufza48WNgp1P1/Ks+R66GKyqTpvo1WFd
# rytENkQ8CUrnYiqV+8glinufOLJ1CU51jo+v2a/aXE5zxJr/LGDB6DS8vscwnPXn
# VCzPmKgkrMa9Mt0ntBfEEmyR0SdN5BjkvZYOBbOp+iqDEBzD6n2yF+VXldRmm/MX
# auWa5OitrU0ZSwhqvC0Obbn2SY8FvoOjgP2lOubUOfdEgyH52W/zTDvw66ik2mGH
# ni0XL1SFCznXzKjbKrQClIpVj1U9DbM+UWF2SgnpfhfUGSm/q2lpoUil5ZJ2pGyT
# VJ+Tvfs1kh39UzXCQJlgwgmvBoJBfKELfaaJ8Xyg/WND
# SIG # End signature block
