$adgrab = Get-ADComputer -Filter * -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap –Auto

$adgrab | out-file "c:\temp\globaladgrab.delete.csv" -force