function Enable-PowershellRemoting.ps1{
[CmdletBinding()] 
param ( 
    [Parameter(Mandatory = $True, 
               ValueFromPipeline = $True, 
               ValueFromPipelineByPropertyName = $True)] 
    [string]$Computername, 
    [Parameter(Mandatory = $False, 
               ValueFromPipeline = $False, 
               ValueFromPipelineByPropertyName = $False)] 
    [string]$PsExecPath = 'C:\PsExec.exe' 
) 
 
begin { 
    ## http://www.leeholmes.com/blog/2009/11/20/testing-for-powershell-remoting-test-psremoting/ 
    function Test-PsRemoting { 
        param ( 
            [Parameter(Mandatory = $true)] 
            $computername 
        ) 
         
        try { 
            $errorActionPreference = "Stop" 
            $result = Invoke-Command -ComputerName $computername { 1 } 
        } catch { 
            Write-Verbose $_ 
            return $false 
        } 
         
        ## I’ve never seen this happen, but if you want to be 
        ## thorough…. 
        if ($result -ne 1) { 
            Write-Verbose "Remoting to $computerName returned an unexpected result." 
            return $false 
        } 
        $true 
    } 
     
    if (!(Test-Connection $Computername -Quiet -Count 1)) { 
        throw 'Computer is not reachable' 
    } elseif (!(Test-Path $PsExecPath)) { 
        throw 'Psexec.exe not found'     
    } 
} 
 
process { 
    if (Test-PsRemoting $Computername) { 
        Write-Warning "Remoting already enabled on $Computername" 
    } else { 
        Write-Verbose "Attempting to enable remoting on $Computername..." 
        & $PsExecPath "\\$Computername" -s c:\windows\system32\winrm.cmd quickconfig -quiet 2>&1> $null 
        if (!(Test-PsRemoting $Computername)) { 
            Write-Warning "Remoting was attempted but not enabled on $Computername" 
        } else { 
            Write-Verbose "Remoting successfully enabled on $Computername" 
        } 
    } 
} 
 
end { 
     
}
}
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwBXCwRCmXUG5Fp+S+YmQ3fKC
# +vugggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSd1lY4lj/B/PzJv+C3qZvzyIbOojAN
# BgkqhkiG9w0BAQEFAASCAQAtsQlvgBetH8TSDjcXbq1vbqWBYUx4qchn4MxOdort
# ygKWoRKWBgy7fft3kXLoFtFABhVv0ttyDHF9vHlbhUubDNRDxOeE6nPGx+B3urFk
# ihYATwpGltxfAT2MKfHipULiGaJh3k9xd6mlh94ZQWnobSwY98PzGWXUXnWQwvIu
# 23ZH8721FjaSdCuGbvWyhyokXIG32z7QFfMwEpfQcD+Xo/CjZG0g7UmA6vgYVsT2
# r3yGlKr02v0iQpO9/I5Y60Ct7S62M5r1AIJbdsHCMIwpSTXgtbqtN1EIVX/ZAFFs
# MYQgsFARBB48ICx8cjcfQvT5oBwT8h6mkibfY2hmNhAI
# SIG # End signature block
