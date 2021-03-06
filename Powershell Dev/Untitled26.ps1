$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
$mySQLCon.Open()
$query = @"
SELECT [PrintServer]
      ,[PrinterName]
      ,[DriverName]
      ,[QueueName]
      ,[PortName]
      ,[HostAddress]
      ,[ShareName]
  FROM [ITS_SDW].[dbo].[NGHS_Windows_Network_Printers]
"@
$Printers_BFDB = $mySQLCon.Query($query)

#$VMCTXPRN_Printers = $Printers_BFDB | where { $_.PrintServer -eq "vmctxprn" }
#$WINPRN_Printers = $Printers_BFDB | where { $_.PrintServer -eq "winprn" }
#$VBINPRINT_Printers = $Printers_BFDB | where { $_.PrintServer -eq "vbinprint" }

$PrinterConnections = Import-Clixml \\hqsbvnxfile1\ITS\Data\DMJ\PS\PSData\all_printers.climxl

$printerconnections_FS = $PrinterConnections | where {$_.computername -like "102FSC*"}

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


$printer_array = New-Object System.Collections.ArrayList

$device = $printerconnections_FS | where {$_.computername -eq "102FSCLT030"}
       
foreach ($object in $device){

$tempobject = "" | Select-Object 'ComputerName','OldConnections','UpdatedConnections','Status'
$tempobject.Oldconnections = @()
$tempobject.UpdatedConnections = @()

$computer = $object.computername

$tempobject.ComputerName = $computer

if ($object.Status -ne "offline"){
    foreach ($printer_connection in $object.printers){
    $tempobject.Oldconnections += $printer_connection
    $tempobject.UpdatedConnections += Get-CorrectPrinterConnection -PrinterConnection $printer_connection
    }
$tempobject.Status = $object.status
$printer_array.Add($tempobject) | Out-Null
        }
    }

	



