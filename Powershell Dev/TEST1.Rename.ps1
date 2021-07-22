$NonComp = Import-Csv "$LogPath\Win10Migration_IncorrectFormat.csv"
$OB_Array = New-Object System.Collections.ArrayList
$OB_Match_Array = New-Object System.Collections.ArrayList
$LogPath = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\GitKraken\Application-Repository\Application-Repository\Grlewis Scripts\Logs\Windows_10_Migration_Container\Logs"
$Ipam_Threshold = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\GitKraken\Application-Repository\ipam_networks.csv"
$NetArray = @($Ipam_Threshold)

foreach ($Object in $NonComp){

    $Computername = $Object.Computername
    $OS = $Object.OS
    $TempObject = "" | Select-Object 'ComputerName', 'OS', 'IP'
    $TempObject.ComputerName = $Computername
    $TempObject.OS = $OS
    $TempObject.IP =  (Test-Connection $Computername -Count 1 -ErrorAction SilentlyContinue).IPV4Address.IpAddresstostring
    $OB_Array.Add($TempObject) | Out-Null
    }
 
$OB_Array | Sort-Object ComputerName | Export-Csv "$LogPath\OB_Array.csv" -NoTypeInformation -Force
$OB_Import = Import-Csv "$LogPath\OB_Array.csv"
$OB_CSS = $OB_Import | select -First 400
$IPAM = $Ipam_Threshold 


foreach ($object in $OB_CSS){
$TempObject = "" | Select-Object 'ComputerName','IP','Location'
    if ($Object.IP -ne ""){
         if ($Object.ComputerName -ne ""){
             #$IP = [IPADDRESS]$object.ip
             #$TempObject.IP = $Linep
             $Object.IP
             #$Tempobject.Location = ($IPAM | Where-Object {$IP.GetAddressBytes()[1] -match $_.network}).location #-and $LineP.GetAddressBytes()[2] -match $IP.GetAddressBytes()[2]}).Location
             #$TempObject.ComputerName = $Object.ComputerName
             #$TempObject.Ip = $Object.IP
           }
          
         
        }
      #$OB_Match_Array.Add($TempObject) | Out-Null
   }
  
  