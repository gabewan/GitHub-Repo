$Engineers = @("Adam Coon","Jamey Gettys","Jamey Gettys","Jamey Gettys","Jamey Gettys")
$Managers = @("Ryan Henry","Ricky Crocker","Rick Ballard")
$Directors = @("Jim Harry")

$FirstTuesday_Engineers = Get-Random -InputObject $Engineers
$FirstTuesday_Managers = Get-Random -InputObject $Managers
$FirstTuesday_Directors = Get-Random -InputObject $Directors

Write-host "Current admin for patching is $FirstTuesday_Engineers. If the Engineer is not accessible contact their Manager: $FirstTuesday_Managers. If the manager is not accesible contact the director: $firstTuesday_Directors."
