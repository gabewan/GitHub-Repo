$Computer = Read-Host "Enter Computer Name"
$Java_Path_x86 = "C:\Program Files (x86)\java\"
$Java_Path_x64 = "C:\Program Files\java\"
$Braselton_Urology = 'Permission java.net.SocketPermission "172.26.42.11", "connect,resolve";'
$Braselton_OBG = 'Permission java.net.SocketPermission "172.26.42.11", "connect,resolve";'
$Gainesville_Urology = 'Permission java.net.SocketPermission "172.26.42.11", "connect,resolve";'
$Gainesville_OBG = 'Permission java.net.SocketPermission "172.26.42.11", "connect,resolve";'
$Cleveland_UC = 'Permission java.net.SocketPermission "172.26.42.11", "connect,resolve";'


if (Test-Connection -ComputerName $Computer)

    {
        Get-WmiObject -Class Win32_Product -ComputerName $Computer -Filter "Name like 'Java%'" -ErrorAction Stop | Select -Expand Version 
            
            if(![System.IO.File]::Exists($Java_Path_x64)){
            
            $Java_Verify_x64 = Get-Childitem "C:\Program Files\java\" | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.name}
            $Java_Policy_x64 = Get-content "C:\Program Files\java\$Java_Verify_x64\lib\security\java.policy"

                if ($Computer -like "216NGP*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x64\lib\security\java.policy" -Value $Cleveland_UC -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "209URO*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x64\lib\security\java.policy" -Value $Braselton_Urology -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "209OBG*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x64\lib\security\java.policy" -Value $Braselton_OBG -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "207URO*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x64\lib\security\java.policy" -Value $Gainesville_Urology -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "207OBG*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x64\lib\security\java.policy" -Value $Gainesville_OBG -ErrorAction SilentlyContinue
                    }

                }
    
     if(![System.IO.File]::Exists($Java_Path_x86)){
     
     $Java_Verify_x86 = Get-Childitem "C:\Program Files (x86)\java\" | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.name}
     $Java_Policy_x86 = Get-content "C:\Program Files\java\$Java_Verify_x86\lib\security\java.policy"

                 if ($Computer -like "216NGP*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x86\lib\security\java.policy" -Value $Cleveland_UC -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "209URO*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x86\lib\security\java.policy" -Value $Braselton_Urology -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "209OBG*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x86\lib\security\java.policy" -Value $Braselton_OBG -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "207URO*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x86\lib\security\java.policy" -Value $Gainesville_Urology -ErrorAction SilentlyContinue
                    }

                if ($Computer -like "207OBG*")
                    {
                      Write-Host "$Computer belongs to Cleveland NGPG"
                      Add-Content -Path "C:\program files (x86)\java\$Java_Policy_x86\lib\security\java.policy" -Value $Gainesville_OBG -ErrorAction SilentlyContinue
                    }

                }
            }