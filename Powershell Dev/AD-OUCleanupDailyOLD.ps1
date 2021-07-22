$Import_Computers_OU = Get-ADComputer -Filter * -SearchBase "CN=Computers,DC=nghs,DC=com" | Select name | Sort-Object name  
$Import_Unassigned_OU = Get-ADComputer -Filter * -SearchBase "OU=unassigned,OU=workstations,DC=nghs,DC=com" | Select name | Sort-Object name 

$REG_EX_Filter_Old = '^([0-9a-zA-Z]{6})([1-2]{1}$)'
$REG_EX_Filter = '(^\d{3})(\w{3})([a-z]{2})(\d{3})'

foreach($Computer in $Import_Computers_OU) {

    if ($computer.name -match $REG_EX_Filter_Old){
                                                             
        if (Test-Connection -ComputerName $Computer.name -count 1 -ErrorAction SilentlyContinue){
         
          $Model = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer.name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PCSystemType #Find the Device Types. Laptop or Desktop (If the device is active)

            if ($Model -eq 1) { #Device is a Desktop and currently Online

              Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOUDep -PassThru #Device is going to be placed in the Desktops OU in Active Directory

              $NewLocation =  "OU=desktops,OU=workstations,DC=nghs,DC=com"
                               
                              }

            If ($Model -eq 2){ #Device is a Laptop and currently Online

                Get-ADComputer $Name |  Move-ADObject -TargetPath $TargetOULap -PassThru #Device is going to be placed in the Desktops OU in Active Directory
                $NewLocation =  "OU=laptops,OU=workstations,DC=nghs,DC=com"

                                    $Name = $Computer.name

                                    Write-Host "$name is a laptop"

                                        }

         }else{
         $Name = $Computer.name

         write-host "$name is inactive"
         
         
         }

                                                       }
  if ($Computer.name -match $REG_EX_Filter){                                                  
                                  
                                   write-host $Computer.name
                                  
                                  }
                                 }       
                                 
                                 
                                 
                                            
foreach($Computer in $Import_Unassigned_OU) {

    if ($computer.name -match $REG_Filter_Old){

                                  write-host $Computer.name

                                                      }
  if ($Computer.name -match $REG_Filter){                                                  
                                  
                                   write-host $Computer.name
                                  
                                  }
                                 }         