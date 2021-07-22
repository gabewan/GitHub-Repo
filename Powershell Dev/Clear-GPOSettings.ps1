function Reset-GPOPolicy
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        # Computer name variable
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $ComputerName,

        # Session Name (Local System or Network Service)
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('LocalSystem', 'NetworkService')]
        $SessionName
    )

    Begin {
        switch ($SessionName) {
            'LocalSystem' { $ID = '0x3e7' }
            'NetworkService' { $ID = '0x3e4' }
            Default { Write-Error 'Invalid Session Name' -ErrorAction Stop}
        }
    } # End Begin
    Process {
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Attempting to connnect to $Computer"
            If (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
                Write-Verbose "Clearing Kerberos Ticket on $Computer for $SessionName"
                $Result = invoke-command -ComputerName $Computer -ScriptBlock { klist -li $Using:ID purge}
                If ($Result[4].TrimStart() -like 'Ticket(s) Purged!') {
                    Write-Output "Success - $Computer"
                } Else {
                    Write-Warning "Failure - $Computer"
                } # End If
            } Else {
                Write-Warning "Unable to connect to $Computer"
            } # End If
        } # End Foreach
    } # End Process
} # End Clear-KerberosTicket
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKPZiXA8i78wYvjRyG5fCcL/z
# PgKgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQRs5yeZupnT6YluDMv/mqG+8CUSTAN
# BgkqhkiG9w0BAQEFAASCAQAHQpMPhoEFiqplZSauNkhhWGbXxCdFrPqkeDYXby53
# Hqm4nV0knyTE/hbeh9d/tlZykA5mW+077s1ztBw/zKWIiSLM4gw4b/0PUzVCPdLE
# OujcGaZTrn8O+bKoLgYSgUSYRftGOAvOwZG7lrQlJS//6irkUIQhwXturZEI1jm0
# B9J9CDodrZrxYdT77Pfa8WxXOWG/oEZ9H86SJPzpA5zrRElyM9b6nD304H/VJXNk
# JF9T6TBwVQS2/siKY5S/Be7dCgSfCa5uevkgoVBUL4gBUHF/McL+PE0nhJPWl5Uk
# aI9SVJlDo5ISO/esd5RY/o8TlcjYBfvp/ZFR6uB0evek
# SIG # End signature block
