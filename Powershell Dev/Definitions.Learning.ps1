Definitions: 
#gpresult /scope user /v - cmd - Get all user gpo's applied


#windows server training {
Create two networks/VLANs (desktops and servers)
Install Windows Server (VM or standard hardware dealer's choice) GUI Mode.
Set up the server as a basic router between the two networks. You'll need 2 NICs to accomplish this (NOTE: unless you have a really good reason for this, you will never do this in a production environment. But because this is a lab situation in VMware workstation and because the product does not support routing between networks, you'll need to put something in place very basic. Windows routing will get the job done and will be on an MCP exam)
Install another server, single NIC on the server VLAN
Create your first active directory domain controller. Install this in GUI mode
Create another server but this time make it a core server. Make it a domain controller
Test AD replication via the gui and cmd.
Create an OU for your workstations, create an OU for your users, and an OU for groups. From now on, any new computer or new user account must go into their respective OU. DO NOT MOVE THE DOMAIN CONTROLLERS FROM THE DOMAIN CONTROLLER OU.
Check out DNS. Do you have a reverse look up zone? No? Then set it up.
Check out DNS. Records can get old and out of date and will screw up name to ip resolution. Make it so that scavenging happens automatically.
You need to block facebook.com via windows DNS. Make it so that when a DNS look up is performed, computers use a loop back address. Test this via cmd to make sure it resolves as expected.
Set up DHCP on the first domain controller.
Set up a scope to hand out IPs for the Desktop VLAN. Make it so that this DHCP scope will be able to give endpoints the information they need networking wise to join a domain
Install a Windows 7 or newer PC on the desktop VLAN
Your desktop's aren't getting IPs. Why? (hint: it's a routing/broadcast/relay issue)
Join that desktop to the domain
Now that you're getting IPs from your DHCP server, configure DHCP clustering. Loadbalancing or failover is your choice. Now test it.
Create a non-domain admin account in AD. Fill out the whole profile once the account is created.
Login to that desktop as a regular AD user and an Admin user. Try to install software under the non-admin account first and then the admin account. What's the difference?
Create another non-admin account. Make this non-admin user a local admin on that computer. Who else is also a local admin before you make any changes,
Review the attributes of that account in AD. You'll need advanced features for this.
Create an AD group. Add the first non-admin account to this group.
On that desktop, install the RSAT tools so you can remotely manage another computer
Setup remote management on the core server so that it can be managed from the MMC of another computer (there are a number of ways to do this)
Find out what server is holding the FSMO roles via the gui and the command prompt.
Split the FSMO roles between the servers. Try to keep forest level and domain level roles together.
On one of the domain controllers, create a file share set it so that only administrators and the second non admin account have access to it. Create another folder and give only the AD group you created permissions.
Use group policy to map both shares as network drives as a computer policy to the desktops.
Login to the desktop as the first domain user. Do you see the network drive mapped in windows explorer? No? Use gpresult to find out why. If you do see it, try to access the drive. You should be denied if you set permissions correctly. Login as the second domain user, they should be able to open the mapped drive.
What if the account in the group tries to access the second drive? You should be able to get in.
login to the workstation as the second non-admin account. You should not have access to this drive because you are not in the group. Do not log off. Add this account to the group. Can you access the drive now? No? Logoff and login back in. Can you access the drive now?
Remove the share from the domain controller. We don't like putting shares on domain controllers if we don't have to.
Build out another two servers and join it to the domain as member servers.
Install DFS and File server roles/features on both servers.
Create a file share on bother servers with the same folder name. Create files on both servers. Make sure they are different. (i.e server1 will have "TextDoc01", server 2 will have "TextDoc02" in their shares).
Create a DFS name space. Add those shares to the name space.
On a domain joined work station, navigate to the DFS namespace you created. You should be able to see both files.
Create a DFS Replication group. Make it so that you have two way replication. You should now see both files on both servers. Make a change on one server and see if it replicates to another server. Does it work? Great. (you can shut down the file servers for now if you want or use them for the next step)
Create another server, join it to the domain, install Windows Deployment Service (WDS) and Windows Server Update Service (WSUS). You can choose to use the file servers you've already created instead of building out another VM. You only need one file server.
Configure WDS so that you can PXE boot to it on the network. Make any required changes to routing and DHCP if need be.
Upload an image to WDS for PXE deployment. Use WAIK and sysprep if you need to. (I haven't done this in the long time so you might not need sysprep anymore with WAIK, look it up)
Create a new desktop VM but do not install an OS on it. Instead tell it to perform a PXE boot when you turn it on, have it install the OS from here.
Configure WSUS so that you will only download Security updates for the desktop and server OS's ( highly recommend that you do not download any updates if you have access to the internet from this server)
Bonus points, install WSUS on another server and create a downstream server)
Create some groups in WSUS. Servers and workstations will do nicely.
Create a new group policy that points workstations into the WSUS workstation group, points to WSUS for updates, and stop workstations from automatically downloading updates.
read up on approving and pushing updates since the current assumption is that there are no updates to be pushed in this enclosed test network since there is no internet access to down load them. I believe there is a way to manually add updates to WSUS but I'm a bit foggy on that. Research it.
Do the same for servers.
create a new AD user via powershell.
Create a new AD group via powershell.
Print a list of all domain users and computers in powershell, names only
use powershell to pull a list of users who have new york as their office. If no users have new york listed as their office, use powershell to set that attribute and then pull users who have new york as their office.
remove a user account from AD using powershell
add a user to a group using powershell
Provision new AD users via a CSV in powershell
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUkR6qU+hIDpobFhc8BhGMJDeQ
# e4egggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBS3afTKN+/UCZ9zHuVjjVImKJFTSjAN
# BgkqhkiG9w0BAQEFAASCAQAzYMZjMXT1g+AIb/7sGJo5lM+2e4VrWgts3QGN5+L5
# t6kNQZ98Z1fGMQPJG2VcGx/zu+rJ+w77Lav96TfW9w3DbNZZMqYpnANEDZYWiUlG
# u0NonSZSH5pv8Pbzi5umsb9w4K3q7KziUozGJe6k46pZIua7wS/bt2ONMoqH2Q0U
# 9eOq4qgWqhs9+QUVU08glYXnpWQoi5kWiWNOqxEzlDTE97Fqy+JTyK2bcl35T9Kk
# /l3wOotXRasKGhTdCcyxZxwO20ECjBb6fM9S9Dzsmiu90X8+WduxqpF/FBjTxP02
# COluZ3cYJT4glPxcg5rV/xkhZVIpN81G3ihkCwA7j4HT
# SIG # End signature block
