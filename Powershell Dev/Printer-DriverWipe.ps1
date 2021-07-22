﻿function Write-ObjectLog {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $InputObject,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if (-Not ($_ | Test-Path) ) {
                    throw "File or folder does not exist" 
                }
                if (-Not ($_ | Test-Path -PathType Leaf) ) {
                    throw "The Path argument must be a file. Folder paths are not allowed."
                }
                return $true
            })]
        $OutputPath,

        # Parameter help description
        [Parameter(Mandatory = $true,
            ParameterSetName = 'JSON')]
        [switch]
        $JsonOutput,

        # Parameter help description
        [Parameter(Mandatory = $true,
            ParameterSetName = 'XML')]
        [switch]
        $XMLOutput,

        # Parameter help description
        [Parameter(Mandatory = $false)]
        [switch]
        $Append
    )
    begin {
        if ($Append) {
            if ($JsonOutput) {
                $FinalOutput = [System.Collections.Generic.List[System.Object]]::new()
                $ImportExistingObject = Get-Content $OutputPath | ConvertFrom-Json

                foreach ($Entry in $ImportExistingObject) {
                    $FinalOutput.Add($Entry)
                }
            }
            elseif ($XMLOutput) {
                $FinalOutput = [System.Collections.Generic.List[System.Object]]::new()
                $ImportExistingObject = Import-Clixml $OutputPath

                foreach ($Entry in $ImportExistingObject) {
                    $FinalOutput.Add($Entry)
                }
            }
        }
        else {
            # Do nothing
        }
    }
	
    process {
        if ($Append) {
            if ($JsonOutput) {
                foreach ($Entry in $InputObject) {
                    $FinalOutput.Add($Entry)
                    try {
                        $FinalOutput | ConvertTo-Json | Out-File $OutputPath
                    }
                    catch {
                        Write-Error "Unable to write to file"
                    }
                    
                }
            }
            elseif ($XMLOutput) {
                foreach ($Entry in $InputObject) {
                    $FinalOutput.Add($Entry)
                    try {
                        $FinalOutput | Export-Clixml -Path $OutputPath
                    }
                    catch {
                        Write-Error "Unable to write to file"
                    }
                    
                }
            }
        }
        else {
            if ($JsonOutput) {
                try {
                    $InputObject | ConvertTo-Json | Out-File $OutputPath
                }
                catch {
                    Write-Error "Unable to write to file"
                }
				
            }
            elseif ($XMLOutput) {
                try {
                    $InputObject | Export-Clixml -Path $OutputPath
                }
                catch {
                    Write-Error "Unable to write to file"
                }
            }
        }
    }
	
    end {
        # Do nothing
    }
}
# Included my write-objectlog, I suggest using JSON formatting.

# Collection to hold log
$Driver_Change = [System.Collections.Generic.List[System.Object]]::New()
$LogPath = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Logs\DriverChange"
if(Test-Path $LogPath){

} else {
    New-Item $LogPath -ItemType Directory -Force
}

$colErrorCollection = [System.Collections.Generic.List[System.Object]]::New()

# Retrieving all printers with desired driver
$Get_Printer_VMCTXPRN = Get-Printer -ComputerName VMCTXPRN -Name * | Where-Object { $_.DriverName -eq "HP Universal Printing PCL 5" }
$Get_Printer_WINPRN = Get-Printer -ComputerName WINPRN -Name * | Where-Object { $_.DriverName -eq "HP Universal Printing PCL 5" }
$Get_Printer_VBINPRINT = Get-Printer -ComputerName VBINPRINT -Name * | Where-Object { $_.DriverName -eq "HP Universal Printing PCL 5" }

# Name of new driver
$Driver_Name = "HP Universal Printing PCL 6"

ForEach ($object in $Get_Printer_VMCTXPRN) {

    try {
        New-Item -Name "$($object.Name).json" -Path $LogPath -ItemType File -Force
    }
    catch {
        $colErrorCollection.Add("Failed to create log file for $($object.name)")
    }

    $Test_Driver_Completion = $null
    # Temp object to add to collection
    $Export_printer_object = [pscustomobject]@{
        Server        = 'VMCTXPRN'
        Printer       = $object.names
        CurrentDriver = $object.drivername
        ChangedDriver = $Driver_Name
        Completed     = $null
        Date          = get-date -Format "MM/dd/yyyy" 
    }
   
    try {
        Set-Printer -ComputerName vmctxprn -Name $object.name -DriverName $driver_name -ErrorVariable $SetPrinterFailed
    }
    catch {
        if ($SetPrinterFailed) {
            $Export_printer_object.Completed = $false
            $Driver_Change.Add($Export_printer_object)
            $colErrorCollection.Add("Failed to change driver for $($object.name)")
            Write-ObjectLog -InputObject $Export_printer_object -OutputPath "$LogPath\$($object.name).json" -JsonOutput -Append

            continue
        }
    }
    
    # Retrieve driver again for verification
    $Test_Driver_Completion = Get-Printer -ComputerName VMCTXPRN -Name $object.name | Select-Object DriverName
    
    if ($Test_Driver_Completion.DriverName -eq "$Driver_Name") {
        # Success
        $Export_printer_object.Completed = $true
    }
    else {
        # Something failed
        $Export_printer_object.Completed = $false
    }

    $Driver_Change.Add($Export_printer_object)

    Write-ObjectLog -InputObject $Export_printer_object  -OutputPath "$LogPath\$($object.name).json" -JsonOutput -Append

}

ForEach ($object in $Get_Printer_WINPRN) {

    try {
        New-Item -Name "$($object.Name).json" -Path $LogPath -ItemType File -Force
    }
    catch {
        $colErrorCollection.Add("Failed to create log file for $($object.name)")
    }

    $Test_Driver_Completion = $null
    # Temp object to add to collection
    $Export_printer_object = [pscustomobject]@{
        Server        = 'WINPRN'
        Printer       = $object.name
        CurrentDriver = $object.drivername
        ChangedDriver = $Driver_Name
        Completed     = $null
        Date          = get-date -Format "MM/dd/yyyy" 
    }
   
    try {
        Set-Printer -ComputerName WINPRN -Name $object.name -DriverName $driver_name -ErrorVariable $SetPrinterFailed 
    }
    catch {
        if ($SetPrinterFailed) {
            $Export_printer_object.Completed = $false
            $Driver_Change.Add($Export_printer_object)
            $colErrorCollection.Add("Failed to change driver for $($object.name)")
            Write-ObjectLog -InputObject $Export_printer_object -OutputPath "$LogPath\$($object.name).json" -JsonOutput -Append

            continue
        }
    }
    
    # Retrieve driver again for verification
    $Test_Driver_Completion = Get-Printer -ComputerName WINPRN -Name $object.name | Select-Object DriverName
    
    if ($Test_Driver_Completion.DriverName -eq "$Driver_Name") {
        # Success
        $Export_printer_object.Completed = $true
    }
    else {
        # Something failed
        $Export_printer_object.Completed = $false
    }

    $Driver_Change.Add($Export_printer_object)

    Write-ObjectLog -InputObject $Export_printer_object  -OutputPath "$LogPath\$($object.name).json" -JsonOutput -Append

}

ForEach ($object in $Get_Printer_VBINPRINT) {

    try {
        New-Item -Name "$($object.Name).json" -Path $LogPath -ItemType File -Force
    }
    catch {
        $colErrorCollection.Add("Failed to create log file for $($object.name)")
    }

    $Test_Driver_Completion = $null
    # Temp object to add to collection
    $Export_printer_object = [pscustomobject]@{
        Server        = 'VBINPRINT'
        Printer       = $object.name
        CurrentDriver = $object.drivername
        ChangedDriver = $Driver_Name
        Completed     = $null
        Date          = get-date -Format "MM/dd/yyyy" 
    }
   
    try {
        Set-Printer -ComputerName vbinprint -Name $object.name -DriverName $driver_name -ErrorVariable $SetPrinterFailed 
    }
    catch {
        if ($SetPrinterFailed) {
            $Export_printer_object.Completed = $false
            $Driver_Change.Add($Export_printer_object)
            $colErrorCollection.Add("Failed to change driver for $($object.name)")
            Write-ObjectLog -InputObject $Export_printer_object -OutputPath "$LogPath\$($object.name).json" -JsonOutput -Append

            continue
        }
    }

    
    # Retrieve driver again for verification
    $Test_Driver_Completion = Get-Printer -ComputerName vbinprint -Name $object.name | Select-Object DriverName
    
    if ($Test_Driver_Completion.DriverName -eq "$Driver_Name") {
        # Success
        $Export_printer_object.Completed = $true
    }
    else {
        # Something failed
        $Export_printer_object.Completed = $false
    }

    $Driver_Change.Add($Export_printer_object)

    Write-ObjectLog -InputObject $Export_printer_object -OutputPath "$LogPath\$($object.name).json" -JsonOutput -Append
}

Write-ObjectLog -InputObject $colErrorCollection -OutputPath "$LogPath\errors.json" -JsonOutput -Append
Write-ObjectLog -InputObject $Driver_Change -OutputPath "$LogPath\allitems.json" -JsonOutput -Append