$Import_NonShared_printers = (get-printer -ComputerName vmctxprn -name * | where {$_.Name -notmatch "Microsoft"} | where {$_.Shared -eq $false}).Name 
$server = 'vmctxprn'

foreach ($p_object in $Import_NonShared_printers){

    Set-Printer -ComputerName $server -Name $p_object -Shared $true -ShareName $p_object 

    }