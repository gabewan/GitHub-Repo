function Global:Ping-IPRange {
    <#
    .SYNOPSIS
        Sends ICMP echo request packets to a range of IPv4 addresses between two given addresses.
 
    .DESCRIPTION
        This function lets you sends ICMP echo request packets ("pings") to 
        a range of IPv4 addresses using an asynchronous method.

        Therefore this technique is very fast but comes with a warning.
        Ping sweeping a large subnet or network with many swithes may result in 
        a peak of broadcast traffic.
        Use the -Interval parameter to adjust the time between each ping request.
        For example, an interval of 60 milliseconds is suitable for wireless networks.
        The RawOutput parameter switches the output to an unformated
        [System.Net.NetworkInformation.PingReply[]].

    .INPUTS
        None
        You cannot pipe input to this funcion.

    .OUTPUTS
        The function only returns output from successful pings.

        Type: System.Net.NetworkInformation.PingReply

        The RawOutput parameter switches the output to an unformated
        [System.Net.NetworkInformation.PingReply[]].

    .NOTES
        Author  : G.A.F.F. Jakobs
        Created : August 30, 2014
        Version : 6

    .EXAMPLE
        Ping-IPRange -StartAddress 192.168.1.1 -EndAddress 192.168.1.254 -Interval 20

        IPAddress                                 Bytes                     Ttl           ResponseTime
        ---------                                 -----                     ---           ------------
        192.168.1.41                                 32                      64                    371
        192.168.1.57                                 32                     128                      0
        192.168.1.64                                 32                     128                      1
        192.168.1.63                                 32                      64                     88
        192.168.1.254                                32                      64                      0

        In this example all the ip addresses between 192.168.1.1 and 192.168.1.254 are pinged using 
        a 20 millisecond interval between each request.
        All the addresses that reply the ping request are listed.

    .LINK
        http://gallery.technet.microsoft.com/Fast-asynchronous-ping-IP-d0a5cf0e

    #>
    [CmdletBinding(ConfirmImpact='Low')]
    Param(
        [parameter(Mandatory = $true, Position = 0)]
        [System.Net.IPAddress]$StartAddress,
        [parameter(Mandatory = $true, Position = 1)]
        [System.Net.IPAddress]$EndAddress,
        [int]$Interval = 30,
        [Switch]$RawOutput = $false
    )

    $timeout = 2000

    function New-Range ($start, $end) {

        [byte[]]$BySt = $start.GetAddressBytes()
        [Array]::Reverse($BySt)
        [byte[]]$ByEn = $end.GetAddressBytes()
        [Array]::Reverse($ByEn)
        $i1 = [System.BitConverter]::ToUInt32($BySt,0)
        $i2 = [System.BitConverter]::ToUInt32($ByEn,0)
        for($x = $i1;$x -le $i2;$x++){
            $ip = ([System.Net.IPAddress]$x).GetAddressBytes()
            [Array]::Reverse($ip)
            [System.Net.IPAddress]::Parse($($ip -join '.'))
        }
    }
    
    $IPrange = New-Range $StartAddress $EndAddress

    $IpTotal = $IPrange.Count

    Get-Event -SourceIdentifier "ID-Ping*" | Remove-Event
    Get-EventSubscriber -SourceIdentifier "ID-Ping*" | Unregister-Event

    $IPrange | foreach{

        [string]$VarName = "Ping_" + $_.Address

        New-Variable -Name $VarName -Value (New-Object System.Net.NetworkInformation.Ping)

        Register-ObjectEvent -InputObject (Get-Variable $VarName -ValueOnly) -EventName PingCompleted -SourceIdentifier "ID-$VarName"

        (Get-Variable $VarName -ValueOnly).SendAsync($_,$timeout,$VarName)

        Remove-Variable $VarName

        try{

            $pending = (Get-Event -SourceIdentifier "ID-Ping*").Count

        }catch [System.InvalidOperationException]{}

        $index = [array]::indexof($IPrange,$_)
    
        Write-Progress -Activity "Sending ping to" -Id 1 -status $_.IPAddressToString -PercentComplete (($index / $IpTotal)  * 100)

        Write-Progress -Activity "ICMP requests pending" -Id 2 -ParentId 1 -Status ($index - $pending) -PercentComplete (($index - $pending)/$IpTotal * 100)

        Start-Sleep -Milliseconds $Interval
    }

    Write-Progress -Activity "Done sending ping requests" -Id 1 -Status 'Waiting' -PercentComplete 100 

    While($pending -lt $IpTotal){

        Wait-Event -SourceIdentifier "ID-Ping*" | Out-Null

        Start-Sleep -Milliseconds 10

        $pending = (Get-Event -SourceIdentifier "ID-Ping*").Count

        Write-Progress -Activity "ICMP requests pending" -Id 2 -ParentId 1 -Status ($IpTotal - $pending) -PercentComplete (($IpTotal - $pending)/$IpTotal * 100)
    }

    if($RawOutput){
        
        $Reply = Get-Event -SourceIdentifier "ID-Ping*" | ForEach { 
            If($_.SourceEventArgs.Reply.Status -eq "Success"){
                $_.SourceEventArgs.Reply
            }
            Unregister-Event $_.SourceIdentifier
            Remove-Event $_.SourceIdentifier
        }
    
    }else{

        $Reply = Get-Event -SourceIdentifier "ID-Ping*" | ForEach { 
            If($_.SourceEventArgs.Reply.Status -eq "Success"){
                $_.SourceEventArgs.Reply | select @{
                      Name="IPAddress"   ; Expression={$_.Address}},
                    @{Name="Bytes"       ; Expression={$_.Buffer.Length}},
                    @{Name="Ttl"         ; Expression={$_.Options.Ttl}},
                    @{Name="ResponseTime"; Expression={$_.RoundtripTime}}
            }
            Unregister-Event $_.SourceIdentifier
            Remove-Event $_.SourceIdentifier
        }
    }
    if($Reply -eq $Null){
        Write-Verbose "Ping-IPrange : No ip address responded" -Verbose
    }

    return $Reply
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrh3CvD58SuKMRhVGSYxJkwcG
# xfGgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSOLxA5p+kJVGHhPdrfmPCU/KM+lDAN
# BgkqhkiG9w0BAQEFAASCAQCNXNrImo5Dt2PcxhUOeEIzyTUaSN3cl50qadZwSO4M
# jJ3hVB0aTHa7oE3Tv4Y2GKynvYSXXjohpdEhK6ALnpcKzs4udcy6QmtOALA0+Wsh
# OoifvKWFSH4WM7BplfHz9Q6KpVLEbEEKyOG3k6RQEeH1IN+ThOh05CaRHhEnhzDi
# EgMxDJvz4rAi/B8p0+9EgQ4sGwKOq1rZ9C0TW0fI6CwLCT2oGBwKJDzZjDW0m/qJ
# VvTxR/eTClL3OkOhl5GWWqAdWAvYBYMNJi2vYSa8bD9DJxsam3x1OKZO7DKiKC1N
# jKYFiIsrhL2QOY3v9whFSiyk/gGviy0iXotjxuCEnLhl
# SIG # End signature block
