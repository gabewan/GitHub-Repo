 $Computername = '102FSCPC007'

 foreach ($Name in $ComputerName) {
            if(!(Test-Connection -Count 1 -ComputerName $Name -Quiet)){
                Write-Error "Computer $Name is offline"
                continue
            }

            $GlobalProfileObject = [pscustomobject]@{
                SID			      = 'GLOBALLY ADDED'
                Username		  = 'GLOBALLY ADDED'
                Name			  = 'GLOBALLY ADDED'
                ADStatus		  = $null
                LastUsed		  = $Null
                Printers		  = $Null
            }

            # Open remote registry
            $RemoteRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$Name)
            
            # Set Global installed printers path
            $GlobalInstalledPrintersPath = 'Software\Microsoft\Windows NT\CurrentVersion\Print\Connections\' 

            # Open global printer installed path
            $GlobalKey = $RemoteRegistry.OpenSubKey($GlobalInstalledPrintersPath)

            # Get the connection names for each printer
            $GlobalInstalledPrinters = $GlobalKey.GetSubKeyNames() | ForEach-Object {$GlobalKey.OpenSubKey($_).GetValue('Printer').ToUpper()}
                        
            # Set as profile object printers
            $GlobalProfileObject.Printers = $GlobalInstalledPrinters
            
            # Add global profile to printer info object, inserts it to the top
            $PrinterInformation.Insert(0, $GlobalProfileObject)

            try{
                # Get all profiles on a computer
                $AllUserProfiles = Get-CimInstance -ClassName Win32_UserProfile -ComputerName $Name | Where-Object {
                    ($_.SID -match $SIDPatter) -and ($_.LocalPath -notlike "*Administrator*")
                }

                # Set bool to not use WMI
                [bool]$useWMI = $false
            }
            catch{
                # Set bool to use WMI
                [bool]$useWMI = $true
                # Fall back to WMI
                $AllUserProfiles = Get-WmiObject -Class Win32_UserProfile -ComputerName $Name | Where-Object {
                    ($_.SID -match $sidpattern) -and ($_.LocalPath -notlike "*Administrator*")
                }
            }
            
            if($null -ne $AllUserProfiles){
                # Get Current user, Printer information is retrieved differently when user is logged on
                if(!($useWMI)){

                    # Use CIM
                    $CurrentUser = (Get-CimInstance -ClassName Win32_ComputerSystem -Property Username -ComputerName $Name).UserName
                } else {

                    # Use WIM
                    $CurrentUser = (Get-WmiObject -Class Win32_ComputerSystem -Property Username -ComputerName $Name).Username
                }
                
                
                # Check if a user is actually logged on
                if($CurrentUser){
                    # Remove NGHS\ from the username
                    $CurrentUser = $CurrentUser -replace '^(.*\\)', ''
                }

                foreach ($UserObject in $AllUserProfiles) {

                    # Skip admin profiles
                    if($UserObject.LocalPath -match 'defaultuser0|NetworkService|LocalService|systemprofile'){
                        continue
                    }

                    # Object to hold user information
                    $UserProfileObject = [pscustomobject]@{
                        SID			      = $null
                        Username		  = $null
                        Name			  = ' '
                        ADStatus		  = $null
                        LastUsed		  = $Null
                        Printers		  = $Null
                        OldPrinters       = $null
                        GlobalPrinters    = $null
                    }

                    # Set SID
                    $UserProfileObject.SID = $UserObject.SID

                    # Search for user in AD by SID
                    $UserADSearch = [adsi]"LDAP://<SID=$($UserProfileObject.SID)>"
                    
                    # Set profile path and remote path
                    # This is used to load remote hives
                    $UserProfilePath = $UserObject.LocalPath
                    $UserRemotePath = ($UserProfilePath).Replace('C:\', "\\$OldComputerName\C`$\")

                    # Detect if AD search was successfull
                    if ($UserADSearch.Properties.sAMAccountName)
                    {
                        # Assign username based on AD variable
                        $UserName = $UserADSearch.Properties.sAMAccountName
                        $UserProfileObject.UserName = ($UserName).ToString()
                        $UserProfileObject.Name = ($UserADSearch.Properties.Name).ToString()
                        
                        # Get enabled status of user.
                        $UserAccountControl = $UserADSearch.Properties.userAccountControl
                        switch ($UserAccountControl) {
                            512 {
                                # User enabled
                                $UserProfileObject.ADStatus = 'Enabled'
                            }
                            514 {
                                # User disabled
                                $UserProfileObject.ADStatus = 'Disabled'
                            }
                            66048 {
                                # User enabled, password never expires
                                $UserProfileObject.ADStatus = 'Enabled'
                            }
                            66050 {
                                # User disabled, password never expires
                                $UserProfileObject.ADStatus = 'Disabled'
                            }
                        }
                    } else {
                        # Set username, based on profile path
                        $UserProfileObject.Username = $UserObject.LocalPath -replace '^(.*\\)', ''
                    }
                    if(!($useWMI)){
                        $UserProfileObject.LastUsed = $UserObject.LastUseTime
                    } else {
                        # Set last used, random errors, unsure of cause
                        $UserProfileObject.LastUsed = $UserObject.ConvertToDateTime($UserObject.LastUseTime)
                    }
                    

                    if($UserProfileObject.Username -eq $CurrentUser){
                        # Open remote registry
                        $RemoteRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('USERS', $Name)

                        # Get registry subkey of user
                        $RegValue = $RemoteRegistry.GetSubKeyNames() | Where-Object {$_ -eq $UserProfileObject.SID}

                        # If subkey is found, get printer connections
                        if($RegValue){
                            # Path to printer connection subkey
                            $PrinterKeyPath = "$RegValue\Printers\Connections\"

                            # Get subkeys in under Connections
                            $PrinterKeyValues = $RemoteRegistry.OpenSubKey($PrinterKeyPath).GetSubKeyNames()

                            # If printer connections exist
                            if($PrinterKeyValues){
                                # Get Connections and replace weird formatting
                                $CurrentUserPrinterConnections = $PrinterKeyValues.Replace(',', '\').ToUpper()
                                $UserProfileObject.OldPrintesr = $CurrentUserPrinterConnections

                                # Add to user object
                                $UserProfileObject.Printers = $CurrentUserPrinterConnections | Where-Object {$PrinterInformation[0].Printers -notcontains $_}
                            } else {
                                # No printers attached to user
                                # Keep object null
                            }
                        } else {
                            # Unable to find user key, is this user even logged on?
                        }
                        $RemoteRegistry.Close()
                    } else {
                        # User is not currently logged on, need to load their hives

                        # Test path to users hive
                        # Some profiles are registered in Windows, but not all create a hive
                        if(Test-Path "$UserRemotePath\NTUSER.dat"){
                            # Add usersid to loaded hives object
                            $UserHivesLoaded.Add("HKU\$UserSID")

                            # Load the hive
                            reg load "HKU\$UserSID" "$UserRemotePath\NTUSER.DAT"

                            # Load USERS registry
                            $UserRegistry = [Microsoft.Win32.RegistryKey]::OpenBaseKey('USERS',0)

                            # Load subkey that matches user SID
                            $RegValue = $UserRegistry.GetSubKeyNames() | Where-Object { $_ -eq $UserSID }
							
							
                            if($null -eq $RegValue){
                                # Subkey for user not found
                                continue
                            } else {
                                 # Path to printer connection subkey
                                $PrinterKeyPath = "$RegValue\Printers\Connections\"

                                # Get subkeys in under Connections
                                $PrinterKeyValues = $RemoteRegistry.OpenSubKey($PrinterKeyPath).GetSubKeyNames()

                                # If printer connections exist
                                if($PrinterKeyValues){
                                    # Get Connections and replace weird formatting
                                    $CurrentUserPrinterConnections = $PrinterKeyValues.Replace(',', '\').ToUpper()
                                    $UserProfileObject.GlobalPrinters = $CurrentUserPrinterConnections

                                    # Add to user object
                                    $UserProfileObject.Printers = $CurrentUserPrinterConnections
                                } else {
                                    # No printers attached to user
                                    # Keep object null
                                }
                            }



                            # Garbage Collect, disconnects the read stream to the hive
                            [System.GC]::Collect()

                            REG DELETE \\ZODIAC\HKLM\Software\MyCo /v MTU
                            # Unload hive, unloading is rate-limited, potential to error out
                            # Will unload after everything is done
                            reg unload "HKU\$userSID"
                        }
                    }

                    # Add profile to printer information object
                    $PrinterInformation.Add($UserProfileObject)
                }
            } else {
                # Unable to find profiles on computer
                # Most likely a WMI permission issue

                Write-Error "Unable to get profile information from $name"
                continue
            }
            # Get USB based printers

            ##
            ## Get USB Printers
            ##

            # Set profile object for USB connections
            $USBProfileObject = [pscustomobject]@{
                SID			      = 'USB BASED'
                Username		  = 'USB BASED'
                Name			  = 'USB BASED'
                ADStatus		  = $null
                LastUsed		  = $Null
                Printers		  = $Null
            }

            # Query WMI for printer information
            if(!($useWMI)){
                # Use CIM
                $USBInstalledPrinters = (Get-CimInstance -Query "SELECT Name FROM Win32_Printer WHERE (PortName LIKE 'USB%')" -ComputerName $Name).Name
            } else {
                # Use WMI
                $USBInstalledPrinters = (Get-WmiObject -Query "SELECT Name FROM Win32_Printer WHERE (PortName LIKE 'USB%')" -ComputerName $Name).Name
            }

            # Check if any USB installed printers
            if($USBInstalledPrinters.Count -gt 0){
                # Prefix each printer with USB in name
                $USBInstalledPrinters = $USBInstalledPrinters | ForEach-Object {"USB\$_"}
            }

            # Set as profile object printers
            $USBProfileObject.Printers = $USBInstalledPrinters

            # Add usb profile to printer info object, inserts it as second row
            $PrinterInformation.Insert(1, $USBProfileObject)
            }