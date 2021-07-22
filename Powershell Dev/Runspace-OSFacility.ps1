$FacilityList = Import-Csv '\\hqsbvnxfile1\global\grlewis\Script_Deployment\facilities.csv'
$NameFormatRegex = '(?<bcode>^\d{3})(?<dept>[a-zA-Z0-9]{3})'#[p,c,P,C,l,L,t,T]{2}\d{3}'
Write-Output 'Getting AD computers'
$ADComputers = Get-ADComputer -Filter * -SearchBase 'OU=Workstations,DC=NGHS,DC=COM' | 
    Where-Object{
        $_.DistinguishedName -notlike "*VDI*"
    } | 
    Sort-Object -Property Name 
       

function GetComputerFacility {
    param(
        $FacilityList,
        $NameFormatRegex,
        $ComputerName
    )
    $TempObject = "" | Select-Object 'ComputerName', 'BuldingCode', 'DepartmentCode', 'Facility', 'OperatingSystem','LastIP','NetworkLocation'

    if($ComputerName -match $NameFormatRegex){
        $Connection = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet
        if($Connection){
            $ConnectionProperties = Test-Connection -ComputerName $ComputerName -Count 1
            $IPV4Address = $ConnectionProperties.IPV4Address
            $TempObject.LastIP = $IPV4Address
            $OperatingSystemCaption = ((Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName -Property Caption).Caption).ToString()
            $TempObject.OperatingSystem = $OperatingSystemCaption
         } else {
             $TempObject.LastIP = 'Offline'
             $TempObject.OperatingSystem = 'Offline'
             $TempObject.NetworkLocation = 'Offline'
         }
        
        
        $TempObject.ComputerName = $ComputerName
        $TempObject.BuldingCode = $Matches.BCode
        $TempObject.DepartmentCode = $Matches.dept
        $TempObject.Facility = ($FacilityList | Where-Object {$_.BuildingCode -eq $matches.BCode -and $_.Department -eq $matches.dept}).facility
        if($TempObject.Facility -eq $Null){
            $TempObject.Facility = "Unknown Combo - " + $TempObject.BuldingCode + $TempObject.DepartmentCode
        }
    }
    return $TempObject
}

$Start = Get-Date
Write-Output "Starting @ $Start"
# Set up runspace pool
$SessionState = [initialsessionstate]::CreateDefault()
#$SessionState.ImportPSModule() # if you want to import a module by name
#$SessionState.ImportPSModuleFromPath() # import by path

$MaxThreads = 50

$RunspacePool = [runspacefactory]::CreateRunspacePool(
    1, # Minimum threads
    $MaxThreads, # Maxmimum threads
    $SessionState,
    $Host # Sets up the runspace host, automatic variable based on the application that is running the script.
)

# https://docs.microsoft.com/en-us/dotnet/api/system.threading.apartmentstate
# Have no idea what this does, I just see it recommended everywhere.
$RunspacePool.ApartmentState = "MTA"

# Starts the pool to allow threads to be created in it
$RunspacePool.Open()

# Create array to hold runspaces and status of them
$RunspacesArray = New-Object System.Collections.ArrayList
Write-Output 'Creating runspaces'
foreach($Computer in $ADComputers){
    $ComputerName = $Computer.Name
    if($ComputerName -notmatch $NameFormatRegex){
        continue # skip this object if it doesn't match regex
    }

    # Create runspace for the object
    $Runspace = [powershell]::Create($SessionState)
    $Runspace.RunspacePool = $RunspacePool

    # Add the script block that runs against the object.
    # I prefer creating a function in the script and calling the scriptblock.
    [void]$Runspace.AddScript((Get-Command -Name GetComputerFacility).ScriptBlock) 

    # Pass parameters to it. The 'Label' must match the parameter name in the SCRIPTBLOCK
    [void]$Runspace.AddParameters(@{
        FacilityList = $FacilityList
        NameFormatRegex = $NameFormatRegex
        ComputerName = $ComputerName
    })

    # Custom object to put in $Runspaces - this is like $TempObject = "" | Select-Object "Properties"
    $RunspaceInfo = [PSCustomObject]@{
        Pipe = $Runspace
        Status = $Runspace.BeginInvoke() # Begins the scriptblock execution
    }

    # Add runspace to info array
    [void]$RunspacesArray.Add($RunspaceInfo)
}

# Object holds results and becomes our output
$ComputerObjects = New-Object System.Collections.ArrayList

# For progress bar
$Total = $RunspacesArray.Count
$Current = 1

while ($RunspacesArray.Status.IsCompleted -contains $False) {
    # Create a progress bar
    Write-Progress -Activity 'Running runspaces' -Status "$Current / $Total" -PercentComplete (($Current*100)/$Total)

    # Grab completed runspaces
    $Completed = $RunspacesArray | Where-Object{
        $PSItem.Status.IsCompleted -eq $true
    }

    foreach($CompletedRunspace in $Completed){
        # Add items to the results object and end them
        [void]$Global:ComputerObjects.Add($CompletedRunspace.Pipe.EndInvoke($CompletedRunspace.Status)) # .EndInvoke stops the runnspace from taking any further instructions
        $CompletedRunspace.Status = $Null # Set to $Null so it is removed from running list
        $Current++
    }
}

# Results are now in $ComputerObjects

# Close and clear the RunspacePool from memore.
$RunspacePool.Close()
$RunspacePool.Dispose()

$Stop = Get-Date
$Seconds = (New-TimeSpan -Start $Start -End $Stop).TotalSeconds
$ComputerObjects | Format-Table
Write-Output "Completed $Total objects in $Seconds"