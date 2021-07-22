function CSV_Header_WhiteSpace(){
    $propertyTranslation = @(
    @{ Name = 'ComputerName'; Expression = { $_.'Computer Name' } }
    @{ Name = 'IP Address';   Expression = { $_.'IP Address'  } }
    @{ Name = 'OS';   Expression = { $_.'OS'  } }
    @{ Name = 'CPU';   Expression = { $_.'CPU'  } }
    @{ Name = 'LRT';   Expression = { $_.'Last Report Time'  } }
)
(Import-Csv -Path $WED_Path) |
Select-Object -Property $propertyTranslation |
Export-Csv -Path  $WED_Path -NoTypeInformation -Force
}