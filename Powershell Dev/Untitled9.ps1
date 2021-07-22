$import_dev = Import-Csv -Path '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\grlewis-repository\Logs\Projects\MedPark 2\Rename_DeviceMoves.csv'

$RX_EPIC = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'

$col_rename = [System.Collections.Generic.List[System.Object]]::new()

foreach ($obj in $import_dev){

    $output_dev = [PSCustomObject]@{

        Computer  = $obj.oldbarcode
        NewName   = $obj.newbarcode
        Completed = $false

        }

    if ($obj.NewBarcode -match $RX_EPIC){
        
         if (Test-Connection -ComputerName $obj.OldBarcode -Count 1 -ErrorAction SilentlyContinue){
            
            Rename-Computer -ComputerName $obj.OldBarcode -NewName $obj.NewBarcode -Force -Restart -WhatIf
           
            $output_dev.Completed = $true
         }   
   
       }
}