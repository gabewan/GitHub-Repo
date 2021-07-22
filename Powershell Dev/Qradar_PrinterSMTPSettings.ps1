$input = Import-Csv 'C:\temp\TempInput.csv'
$winprn = Import-Csv '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\printers_winprn.csv'
$vmctxprn = Import-Csv '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\GitKraken\Application-Repository\Application-Repository\Grlewis Scripts\Reports\printers.csv'
$getdate = Get-Date -Format FileDate
$array = [System.Collections.Generic.List[System.Object]]::new()

foreach ($object in $input){

     $tempobject = [pscustomobject]@{
        printer = $null 
        port = $null
        server = $null
        vmctxprn = $null
        winprn = $null
        }
 
    if ($winprn.portname -contains $object.port){
         $tempObject.printer = (($winprn | where {$_.portname -match $object.port}).name)
         $tempobject.port = $object.port
         $tempobject.server = "winprn"
        } 

    if ($vmctxprn.portname -contains $object.port){
        $tempobject.printer = (($vmctxprn | where {$_.portname -match $object.port}).name)  
        $tempobject.port = $object.port
        $tempobject.server = "vmctxprn"
        }

    if ($vmctxprn.portname -contains $object.port -and $winprn.portname -contains $object.port){
        $tempobject.printer = $object.name
        $tempobject.port = $object.port
        $tempobject.server = "both print servers"
        $tempobject.vmctxprn = $tempobject.printer = (($vmctxprn | where {$_.portname -match $object.port}).name)
        $tempObject.winprn = (($winprn | where {$_.portname -match $object.port}).name)  
        }

    if ($winprn.portname -notcontains $object.port -and $vmctxprn.portname -notcontains $object.port){
        $tempobject.printer = $object.name
        $tempobject.port = $object.port       
        $tempobject.server = "NOCONNECTION"
        }
        
         $array.add($tempobject)
    }

$array_nondiscoverable = [System.Collections.Generic.List[System.Object]]::new()

foreach ($Printer in $array){
    if ($Printer.printer -eq $null){
        $array_nondiscoverable.add($Printer.port)    
        }

}

$array_nondiscoverable_serverlist = [System.Collections.Generic.List[System.Object]]::new()
foreach($port in $array_nondiscoverable){
   $tempobj = [pscustomobject]@{
        printer = $null 
        port = $null
        server = $null
        vmctxprn = $null
        winprn = $null
   }
    if ($winprn.portname -contains $port){
         $tempObj.printer = (($winprn | where {$_.portname -match $port}).name)
         $tempobj.port = $port
         $tempobj.server = "winprn"
        } 
    if ($vmctxprn.portname -contains $port){
        $tempobj.printer = (($vmctxprn | where {$_.portname -match $port}).name)  
        $tempobj.port = $port
        $tempobj.server = "vmctxprn"
        }
    if ($winprn.portname -notcontains $port -and $vmctxprn.portname -notcontains $port){
        $tempobj.printer = "NOPRINTERCONNECTION"
        $tempobj.port = $port
        $tempobj.server = "NOCONNECTION"
        }
         $array_nondiscoverable_serverlist.add($tempobj)
}

$array_nondiscoverable_serverlist | Export-Csv "c:\temp\$getdate.csv" -Force -NoTypeInformation
