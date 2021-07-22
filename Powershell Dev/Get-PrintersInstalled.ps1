
$executable = "C:\temp\pa\PrinterInstall.cmd"
$executable2 = "C:\temp\pa\PrinterReport.cmd"
$PSExec = "C:\Windows\System32\PSExec.exe"
$gc = Get-Credential
$user = $gc.UserName
$pass = $gc.GetNetworkCredential().Password

New-Item -Path "\\102lw1pc990\c$\temp\pa" -Force -Name "PrinterReport.cmd" -ItemType "file" -Value "wmic printer get name > c:\temp\pa\printerlist.csv"
Start-Process -Filepath "$PSExec" -ArgumentList "\\102lw1pc990 -s -u $user -p $pass $executable2" -Wait


$Get = Import-Csv "\\102lw1pc990\c$\temp\pa\printerlist.csv"

$Get