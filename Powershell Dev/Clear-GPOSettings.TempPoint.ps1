function Clear-KerberosTicket
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUw+C8XKz4AU8qb/ED+/pRu9Cr
# YUygggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQ0Y61VR9yg8MfWCcV2iwPOgaeORTAN
# BgkqhkiG9w0BAQEFAASCAQBzRA9jIbRofmwKXD4fPiV5e+1Ms/IeVAjsj1e42fNN
# CNE5CoXUVKi4YsWha8m5EjJAT/Z7gGVMWrAGl5MsDML2sgSx7R5N//Ya7vDe5euf
# IjZo8uDG3/82Scfble9XzVBusxX9LpFpYRuzg9JVpHEV0FrccT0bFxA35oQK4gjN
# R6TGwBMwnSPzT8PEtKZXO7C3n6I+9reRN7R7koOqY+BWABsBEeADNnoxfNYyu6/i
# vbfHfjkGRO2vkswGjKCFfrplvzhqZp/sPEku+h05jKfSO7gUNW5s0NaeWn+PQW9L
# kW7M52ppvgX6YeQBa1+LCWZrSKulXBPQ/shUnjbuLpV3
# SIG # End signature block
