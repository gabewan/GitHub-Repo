$Hospice_Employees = Get-ADGroupMember -Identity 'Hospice'
$Export_Objects = New-Object System.Collections.ArrayList 


ForEach ($user in $Hospice_Employees) {

    if ($user.distinguishedName  -like "*OU=People*") {
        
        if ($user.distinguishedName -notlike "*OU=ITS*"){

         $TempObject = "" | Select-Object 'UserName', 'EmployeeID', 'OfficeVersion'

         $Object_User = Get-ADUser $user -Properties MemberOf 

        if ($Object_User.MemberOf -match "O365E1"){
        
         $Office_Version = "Office 365 - E1 User"
                
           }

        if ($Object_User.MemberOf -match "Office 365 Users") {
            
        $Office_Version = "Office 365 - E3 User"
 
           }

        $TempObject.UserName = $user.name

        $TempObject.EmployeeID = $user.SamAccountName | select -First 6

        $TempObject.OfficeVersion = $Office_Version
        
        $Export_Objects.Add($TempObject) | Out-Null

         
         }
      }
   }

$Export_Objects | Sort-Object UserName
       
(get-printer -ComputerName VMCTXPRN -Name $Printer_Trim).DriverName