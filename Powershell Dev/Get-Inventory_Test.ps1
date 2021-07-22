$Device_Inventory = @(
'9N19BZ1'
'9MZ7BZ1'
'9N08BZ1'
'7SL1482'
'9N18BZ1'
'FG3Z6Y1'
'9N17BZ1'
'9MZ9BZ1'
)

$Export_Inventory = New-Object System.Collections.ArrayList

foreach ($Device in $Device_Inventory){

$Array_Inventory = "" | Select-Object 'Device', 'User', 'Model', 'BiosVersion', 'ProcessorName', 'OSVersion','Office' #Create a storage array 

if (Test-Connection $Device -count 1 -ErrorAction SilentlyContinue){
        write-host $Device


        $Array_Inventory.Device = $Device
        #$Array_Inventory.User = ($Device_Inventory | Where-Object {$_ -eq $Device}).User
        $Array_Inventory.Model = (Get-WmiObject -ComputerName $Device -Class:Win32_ComputerSystem).Model 
        $Array_Inventory.BiosVersion = (Get-WmiObject -Class Win32_Bios -ComputerName $device).SMBIOSBIOSVersion 
        $Array_Inventory.ProcessorName = (Get-WmiObject -Class Win32_Processor -ComputerName $Device).Name
        $Array_Inventory.OSVersion = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Device).Version 
        $Array_Inventory.Office = (Get-WmiObject win32_product -ComputerName $Device | Where {$_.name -like "*Microsoft Office Professional*"}).Name
        $Export_Inventory.Add($Array_Inventory) | Out-Null

    } 
}
  
  $Export_Inventory | Export-Csv c:\temp\marios_report.csv -NoTypeInformation
