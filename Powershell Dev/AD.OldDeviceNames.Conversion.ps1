$NameFormatRegex = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'
$REG_EX_Filter_Old = '^([a-zA-Z0-9]{6})([1-2]{1})$' 
$TAMPEDObjects = New-Object System.Collections.ArrayList

$AllComputers = Get-ADComputer -Filter * -SearchBase 'DC=NGHS,DC=COM' | 
    Where-Object{
        $_.DistinguishedName -notlike "*VDI*" -and $_.DistinguishedName -notlike "*VM*" -and $_.DistinguishedName -notlike "*HQ*" -and $_.DistinguishedName -notlike "*VBAUD*"
    }  | 
    Sort-Object -Property Name 

foreach($ComputerObj in $AllComputers){
   
   $TAMPOBjects = "" | Select-Object 'Computer','OldName'
    
    if ($ComputerObj.Name -match "$REG_EX_Filter_Old"){
        $TampOBjects.Computer = $Computerobj.Name
        $TampOBjects.Oldname = $ComputerObj.DistinguishedName
        $TAMPEDOBjects.Add($TampObjects) | Out-Null
     }
  }


$OnlineObjects = New-Object System.Collections.ArrayList

foreach($Device in $TAMPEDObjects.Computer){

   $OnlineObjects1 = "" | Select-Object 'Computer','IP','Offline'

   $IP = Test-Connection $Device -count 1 -ErrorAction SilentlyContinue -Quiet

    if ($IP -eq $true){
        
        $OnlineObjects1.Computer = $Device
        $OnlineObjects1.IP = (Test-Connection $Device -count 1 -ErrorAction SilentlyContinue).IPV4Address
        $OnlineObjects1.Offline = 'No'
        $OnlineObjects.Add($OnlineObjects1) | Out-Null
        
        } 
        
     if ($IP -eq $false){

        $OnlineObjects1.Computer = $Device 
        $OnlineObjects1.IP = ""
        $OnlineObjects1.Offline = 'Yes'
        $OnlineObjects.Add($OnlineObjects1) | Out-Null

        }   

   
}