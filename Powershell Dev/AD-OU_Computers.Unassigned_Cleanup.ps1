$Export_Objects_CompOU = New-Object System.Collections.ArrayList
$Export_Objects_UnasOU = New-Object System.Collections.ArrayList

$REG_Filter_Old = '^([0-9a-zA-Z]{6})([1-2]{1}$)'
$REG_Filter = '(^\d{3})(\w{3})([a-z]{2})(\d{3})'

$Import_Computers_OU = Get-ADComputer -Filter * -SearchBase "CN=Computers,DC=nghs,DC=com" | Select name | Sort-Object name  
$Import_Unassigned_OU = Get-ADComputer -Filter * -SearchBase "OU=unassigned,OU=workstations,DC=nghs,DC=com" | Select name | Sort-Object name 

$TargetOULap = "OU=laptops,OU=workstations,DC=nghs,DC=com"
$TargetOUDep = "OU=desktops,OU=workstations,DC=nghs,DC=com"

$Export_Computers_OU = $Import_Computers_OU.name |  Out-File '\\hqsbvnxfile1\global\grlewis\logs\Export_Computers_OU.csv' -Force 
$Export_Computers_OU = $Import_Unassigned_OU.name |  Out-File '\\hqsbvnxfile1\global\grlewis\logs\Export_Unassigned_OU.csv' -Force 

foreach($Computer in $Import_Computers_OU) {

$TempObject_Computers = "" | Select-Object 'Computer', 'CurrentLocation', 'NewLocation','Date'

    if ($Computer.name -match $REG_Filter){

        if (Test-Connection -ComputerName $Computer.name -count 1 -ErrorAction SilentlyContinue){
         
         Get-WmiObject -Computer $Computer.Name -Class "Win32_ComputerSystem"                  
         
         Get-ADComputer $Computer.name |  Move-ADObject -TargetPath $TargetOULap -PassThru

         $Device = $Computer.name

         $Comp_Array = $Device

         $CurrentLocation = "CN=Computers,DC=nghs,DC=com"

         $NewLocation = "$TargetOULap"
                           
         $Date = Get-Date  

     }
   
                                        
                                      
                                    


                                    
                                    $Name = $Computer.name

                                    $Model = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PCSystemType 

                                    if ($Model -eq 1) {

                                    Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOUDep -PassThru
                                    $NewLocation =  "OU=desktops,OU=workstations,DC=nghs,DC=com"

                                        }

                                    If ($Model -eq 2){

                                    Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOULap -PassThru
                                    $NewLocation =  "OU=laptops,OU=workstations,DC=nghs,DC=com"

                                        }
         
                                    $Device = $Name

                                    $Comp_Array = $Device

                                    $CurrentLocation = "CN=Computers,DC=nghs,DC=com"

                                    $Date = Get-Date

                                                       }
                                                      }
                                      

$TempObject_Computers.Computer = $Comp_Array

$TempObject_Computers.CurrentLocation = $CurrentLocation

$TempObject_Computers.NewLocation = $NewLocation

$TempObject_Computers.Date = $Date

$Export_Objects_CompOU.Add($TempObject_Computers) | Out-Null

}

foreach($Computer in $Import_Unassigned_OU) {

$TempObject_Unassigned = "" | Select-Object 'Computer', 'CurrentLocation', 'NewLocation','Date'

If ($Computer.name -like '*LT*') {
   
   if ($Computer.name -notlike '*VM*'){
    
      if ($Computer.name -notlike '*XEN*'){

         if ($Computer.name -notlike '*NEWLINE*'){

             if ($Computer.name -notlike '*LENO*'){
                      
                  if ($Computer.name -notlike '*HQ*'){
                                                   
                           Get-ADComputer $Computer.name |  Move-ADObject -TargetPath $TargetOULap -PassThru

                           $Device = $Computer.name

                           $Comp_Array = $Device

                           $CurrentLocation = "CN=Computers,DC=nghs,DC=com"

                           $NewLocation = "$TargetOULap"
                           
                           $Date = Get-Date  
                                                      }
                                                  }
                                              }
                                          }
                                      }
                                  } 
If ($Computer.name -like '*PC*'){

   if ($Computer.name -notlike '*VM*'){

     if ($Computer.name -notlike '*XEN*'){

         if ($Computer.name -notlike '*NEWLINE*'){

              if ($Computer.name -notlike '*LENO*'){

                  if ($Computer.name -notlike '*HQ*'){
                    
                    if ($Computer.name -notlike '*PACS*'){
                        
                        Get-ADComputer $Computer.name |  Move-ADObject -TargetPath $TargetOUDep -PassThru

                        $Device = $Computer.name

                        $Comp_Array = $Device

                        $CurrentLocation = "CN=Computers,DC=nghs,DC=com"

                        $NewLocation = "$TargetOUDep"
                           
                        $Date = Get-Date
                        
                                                      }
                                                     }
                                                    }
                                                   }
                                                  }
                                                 }
                                                }
If ($Computer.name -like '*DESKTOP*'){

   if ($Computer.name -notlike '*VM*'){

     if ($Computer.name -notlike '*XEN*'){

         if ($Computer.name -notlike '*NEWLINE*'){

             if ($Computer.name -notlike '*LENO*'){
                       
                 if ($Computer.name -notlike '*HQ*'){
                    
                    if ($Computer.name -notlike '*PACS*'){
                        
                       Get-ADComputer $Computer.name |  Move-ADObject -TargetPath $TargetOUDep -PassThru

                       $Device = $Computer.name

                       $Comp_Array = $Device

                       $CurrentLocation = "CN=Computers,DC=nghs,DC=com"

                       $NewLocation = "$TargetOUDep"
                           
                       $Date = Get-Date

                                                         }
                                                        }
                                                       }
                                                      }
                                                     }
                                                    }
                                                   }
If ($Computer.name -like '*2'){

   if ($Computer.name -notlike '*VM*'){

     if ($object.name -notlike '*XEN*'){

         if ($Computer.name -notlike '*NEWLINE*'){

             if ($Computer.name -notlike '*LENO*'){
                
                if ($Computer.name -notlike '*HQ*'){
                    
                    if ($Computer.name -notlike '*VC*'){
                        
                        if ($Computer.name -notlike '*TEST*'){

                            if ($Computer.name -notlike '*CLEAR*'){
                                
                                if ($Computer.name -notlike '*NGHS*'){

                                    $Name = $Computer.name

                                    $Model = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PCSystemType 

                                    if ($Model -eq 1) {

                                    Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOUDep -PassThru
                                    $NewLocation =  "OU=desktops,OU=workstations,DC=nghs,DC=com"

                                        }

                                    If ($Model -eq 2){

                                    Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOULap -PassThru
                                    $NewLocation =  "OU=laptops,OU=workstations,DC=nghs,DC=com"

                                        }
                                    
                                    $Device = $Name

                                    $Comp_Array = $Device

                                    $CurrentLocation = "CN=Computers,DC=nghs,DC=com"

                                    $NewLocation = "$TargetOUDep"
                           
                                    $Date = Get-Date

                                                       }
                                                      }
                                                     }
                                                    }
                                                   }
                                                  }
                                                 }
                                                }
                                               }
                                              }
If ($Computer.name -like '*1'){

   if ($Computer.name -notlike '*VM*'){

     if ($Computer.name -notlike '*XEN*'){

         if ($Computer.name -notlike '*NEWLINE*'){

             if ($Computer.name -notlike '*LENO*'){
                
                if ($Computer.name -notlike '*HQ*'){
                    
                    if ($Computer.name -notlike '*VC*'){
                        
                        if ($Computer.name -notlike '*TEST*'){

                            if ($Computer.name -notlike '*CLEAR*'){
                                
                                if ($Computer.name -notlike '*NGHS*'){

                                    $Name = $Computer.name

                                    $Model = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PCSystemType 

                                    if ($Model -eq 1) {

                                    Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOUDep -PassThru
                                    $NewLocation =  "OU=desktops,OU=workstations,DC=nghs,DC=com"

                                        }

                                    If ($Model -eq 2){

                                    Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOULap -PassThru
                                    $NewLocation =  "OU=laptops,OU=workstations,DC=nghs,DC=com"

                                        }

                                    $Device = $Name

                                    $Comp_Array = $Device

                                    $CurrentLocation = "CN=Computers,DC=nghs,DC=com"

                                    $NewLocation = "$TargetOUDep"
                           
                                    $Date = Get-Date

                                                       }
                                                      }
                                                     }
                                                    }
                                                   }
                                                  }
                                                 }
                                                }
                                               }
                                              }

$TempObject_Unassigned.Computer = $Comp_Array

$TempObject_Unassigned.CurrentLocation = $CurrentLocation

$TempObject_Unassigned.NewLocation = $NewLocation

$TempObject_Unassigned.Date = $Date

$Export_Objects_UnasOU.Add($TempObject_Unassigned) | Out-Null

}

$Export_Objects_CompOU | Export-Csv -Path "\\hqsbvnxfile1\global\grlewis\logs\Updated_Export_ComputersOU.csv" -Force -NoTypeInformation
$Export_Objects_UnasOU | Export-Csv -Path "\\hqsbvnxfile1\global\grlewis\logs\Updated_Export_UnassignedOU.csv" -Force -NoTypeInformation

$Import_Daily_Computers_OU = Import-Csv "\\hqsbvnxfile1\global\grlewis\logs\Updated_Export_ComputersOU.csv" 
$Import_Daily_Unassigned_OU = Import-Csv "\\hqsbvnxfile1\global\grlewis\logs\Updated_Export_UnassignedOU.csv"

$Tech_Log = ""  