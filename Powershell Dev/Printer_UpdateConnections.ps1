function Get-CorrectPrinterConnection {
    <#
    .SYNOPSIS
        Takes a printer connection and gets the correct one from VMCTXPRN
    .DESCRIPTION
        Verifies the printer connection passed to it is the best one to use, using correct print server and correct naming scheme
    .EXAMPLE
        Get-CorrectPrinterConnection -PrinterConnection \\SERVER\PrinterName
    .EXAMPLE
        Get-CorrectPrinterConnection -PrinterConnection \\SERVER\PrinterName -NullOnNonExistent
    .INPUTS
        [System.String]
    .OUTPUTS
        [System.String]
    #>
    [CmdletBinding()]
    [OutputType([String])]
    Param (
        # Printer connection
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrinterConnection,
        #Use to return null rather than old printer connection
        [Parameter(Mandatory = $False)]
        [switch]
        $NullOnNonExistent = $false
    )
    begin {
        $VMCTXPrinters = get-printer -ComputerName vmctxprn
        $WINPrnPrinters = get-printer -ComputerName winprn
        $VBINPrnPrinters = get-printer -ComputerName vbinprint
    }
    process {
        $OldPrinterConnection = $PrinterConnection
        if($OldPrinterConnection -match '\\\\\\\\'){ # Matches four '\'s, this is mainly for when the printer lists from registry are saved as JSON.
            $ConnectionParts = $OldPrinterConnection.Replace('\\', '\')
        }
        $ConnectionParts = $OldPrinterConnection
        $ConnectionParts = $ConnectionParts.Replace('\\', '')
        $ConnectionParts = $ConnectionParts.Split('\')
        $ServerConnectionPart = $ConnectionParts[0]
        $PrinterNameConnectionPart = $ConnectionParts[1]
        if ($ServerConnectionPart -match 'WINPRN') {
            if ($PrinterNameConnectionPart -match "\d{3}\w{3}(XR|HP)\d{3}") {
                $VMCTXName = $VMCTXPrinters | Where-Object { $_.Name -eq $PrinterNameConnectionPart }
                $NewPrinterName = $VMCTXName.Name
            } else {
                $OldPrinterPort = ($VMCTXPrinters | Where-Object { $_.Name -eq $PrinterNameConnectionPart }).PortName
                if ($OldPrinterPort -match '_') {
                    $OldPrinterPort = $OldPrinterPort.Replace('_', '')
                }
                if($Null -eq $OldPrinterPort){
                    $OldPrinterPort = ($WINPrnPrinters | Where-Object { $_.Name -eq $PrinterNameConnectionPart }).PortName
                    if ($OldPrinterPort -match '_') {
                        $OldPrinterPort = $OldPrinterPort.Replace('_', '')
                    }
                }
                $VMCTXPRN_Objects = $VMCTXPrinters | Where-Object { $_.PortName -like $OldPrinterPort }
                if ($VMCTXPRN_Objects.Count -gt 1) {
                    $NewPrinterName = ($VMCTXPRN_Objects | Where-Object { $_.Name -match "\d{3}\w{3}(XR|HP)\d{3}" }).Name
                } else {
                    $NewPrinterName = $VMCTXPRN_Objects.Name
                }
            }
        }
        if ($ServerConnectionPart -match 'VBINPRINT') {
            if ($PrinterNameConnectionPart -match "\d{3}\w{3}(XR|HP)\d{3}") {
                $VMCTXName = $VMCTXPrinters | Where-Object { $_.Name -eq $PrinterNameConnectionPart }
                $NewPrinterName = $VMCTXName.Name
            } else {
                $OldPrinterPort = ($VMCTXPrinters | Where-Object { $_.Name -eq $PrinterNameConnectionPart }).PortName
                if ($OldPrinterPort -match '_') {
                    $OldPrinterPort = $OldPrinterPort.Replace('_', '')
                }
                if($Null -eq $OldPrinterPort){
                    $OldPrinterPort = ($VBINPrnPrinters | Where-Object { $_.Name -eq $PrinterNameConnectionPart }).PortName
                    if ($OldPrinterPort -match '_') {
                        $OldPrinterPort = $OldPrinterPort.Replace('_', '')
                    }
                }
                $VMCTXPRN_Objects = $VMCTXPrinters | Where-Object { $_.PortName -like $OldPrinterPort }
                if ($VMCTXPRN_Objects.Count -gt 1) {
                    $NewPrinterName = ($VMCTXPRN_Objects | Where-Object { $_.Name -match "\d{3}\w{3}(XR|HP)\d{3}" }).Name
                } else {
                    $NewPrinterName = $VMCTXPRN_Objects.Name
                }
            }
        } elseif ($ServerConnectionPart -match 'VMCTXPRN') {
            if ($PrinterNameConnectionPart -match "\d{3}\w{3}(XR|HP)\d{3}") {
                $NewPrinterName = $PrinterNameConnectionPart
            } else {
                $OldPrinterPort = ($VMCTXPrinters | Where-Object { $_.Name -eq $PrinterNameConnectionPart }).PortName
                if ($OldPrinterPort -match '_') {
                    $OldPrinterPort = $OldPrinterPort.Replace('_', '')
                }
                $VMCTXPRN_Objects = $VMCTXPrinters | Where-Object { $_.PortName -match $OldPrinterPort }
                if ($VMCTXPRN_Objects.Count -gt 1) {
                    $NewPrinterName = ($VMCTXPRN_Objects | Where-Object { $_.Name -match "\d{3}\w{3}(XR|HP)\d{3}" }).Name
                } else {
                    $NewPrinterName = $VMCTXPRN_Objects.Name
                }
            }
        }
        if ($Null -eq $NewPrinterName) {
            # Something went wrong
            if($NullOnNonExistent){
                Write-Error 'Printer does not exist on print servers'
                $NewPrinterConnection = $null
            } else {
                if($OldPrinterConnection -match '\\\\\\\\'){ # Matches four '\'s, this is mainly for when the printer lists from registry are saved as JSON.
                    $NewPrinterConnection = $OldPrinterConnection.Replace('\\', '\')
                }
                $NewPrinterConnection = $OldPrinterConnection
            }
        } else {
            $NewPrinterConnection = "\\VMCTXPRN\$NewPrinterName"
        }
        return $NewPrinterConnection
    }
}
$PrinterConnections = Import-Clixml '\\hqsbvnxfile1\ITS\Data\DMJ\PS\PSData\all_printers.climxl'
$PrinterConnections_FS = $PrinterConnections | Where-Object {$_.computername -like "102FSCPC*"}
$Printer_Array = [System.Collections.Generic.List[System.Object]]::New()
$Device_Printer_Information = [System.Collections.Generic.List[System.Object]]::New()
$RemoteRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$Name)
[string]$sidpattern = 'S-1-5-21-\d+-\d+\-\d+\-\d+$'

foreach ($object in $PrinterConnections_FS){
    $Temp_Objects = [pscustomobject]@{
        ComputerName        = $null
        OldConnections	    = $null
        UpdatedConnections  = $null
        Status		        = $null
    }
    $Status = $object.status
    $Temp_Objects.Status = $Status
    $Temp_Objects.UpdatedConnections = [System.Collections.Generic.List[System.Object]]::New()
    $Temp_Objects.OldConnections = [System.Collections.Generic.List[System.Object]]::New()
    $Temp_Objects.ComputerName = $object.ComputerName
        foreach ($printer_connection in $object.printers){
            $Temp_Objects.Oldconnections.Add($printer_connection)
            $UpdatedConnections = Get-CorrectPrinterConnection -PrinterConnection $printer_connection
            $Temp_Objects.UpdatedConnections.Add($UpdatedConnections)
            }
    $Printer_Array.Add($Temp_Objects)
}
foreach ($N_Object in $PrinterArray){
 if ($N_object.Status -eq 'Complete'){
    $Name = $N_Object.ComputerName
        $RemoteRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$Name)
        $PrinterPath_Global = 'Software\Microsoft\Windows NT\CurrentVersion\Print\Connections\'
        $GlobalKey = $RemoteRegistry.OpenSubKey($PrinterPath_Global)
        $GlobalInstalledPrinters = $GlobalKey.GetSubKeyNames() | ForEach-Object {$GlobalKey.OpenSubKey($_).GetValue('Printer').ToUpper()}
    }
}