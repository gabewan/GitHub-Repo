class MSSQL {
       
    [string]$SQLInstance
    [string]$DatabaseName
    [System.Data.SQLClient.SQLConnection]$SQLConnection
    
    MSSQL([string]$SQLInstance, [string]$DatabaseName) {
           
        [void][Reflection.Assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
           
        $this.SQLInstance = $SQLInstance
        $this.DatabaseName = $DatabaseName
    }
    
    Open() {
           
        $ConnectionString = "Integrated Security=True;Initial Catalog=$($this.DatabaseName);Data Source=$($this.SQLInstance);"
        $Connection = New-Object System.Data.SQLClient.SQLConnection($ConnectionString)
           
        $Connection.Open()
           
        $this.SQLConnection = $Connection
    }
    
    Open([String]$userName, [System.Security.SecureString]$userPwd) {
    
        if (!$userPwd.IsReadOnly()) {
            $userPwd.MakeReadOnly()
        }
           
        $sqlCred = New-Object System.Data.SqlClient.SqlCredential($userName, $userPwd)
        $ConnectionString = "Initial Catalog=$($this.DatabaseName);Data Source=$($this.SQLInstance);"
        $Connection = New-Object System.Data.SQLClient.SQLConnection($ConnectionString, $sqlCred)
           
        $Connection.Open()
           
        $this.SQLConnection = $Connection
    }
    
    Close() {
           
        $this.SQLConnection.Close()
           
    }
    
    [System.Data.DataTable]Query([String]$SQLQuery) {
           
        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
        $DataSet = New-Object System.Data.DataSet
           
        $SqlCmd.CommandText = $SqlQuery
        $SqlCmd.Connection = $this.SqlConnection
           
        $SqlAdapter.SelectCommand = $SqlCmd
           
        $SqlAdapter.Fill($DataSet) | Out-Null
           
        Return $DataSet.Tables[0]
    }
    
    [System.String]Exec([String]$SQLQuery) {
           
        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
           
        $SqlCmd.CommandText = $SqlQuery
        $SqlCmd.CommandTimeout = 300
        $SqlCmd.Connection = $this.SqlConnection
           
        [System.String]$Result = $SqlCmd.ExecuteNonQuery()
           
        return $Result
    }
}

$printers_VMCTXPRN = Get-Printer -ComputerName vmctxprn -Name * | where { $_.Name -match 'XR|HP' } | Sort-Object | select Name, Portname 

$import_printers = Import-Csv C:\temp\Book2.csv # MEMBERS: Barcode,IP,MAC,Make

$col_printers = [System.Collections.Generic.List[System.object]]::new()
$col_sql = [System.Collections.Generic.List[System.Object]]::new()

$RX_EPIC = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'

$vpsx = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\grlewis-repository\Logs\Export_VPSX.csv" 
$COL_vpsx = @($vpsx)

$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
$mySQLCon.Open() 
$query = @"
SELECT [ClientName]
 ,[Printer]
 ,[isDefault]
 ,[PriKey]
FROM [ITS_SDW].[dbo].[NGHS_Virtual_Printer_Mapping]
"@
$tc_results = $mySQLCon.Query($query)


# BUILDING PRINTERS - VMCTXPRN
foreach ($object in $import_printers) {

    $obj_output_printers = [PSCustomObject]@{
    
        Printer  = $object.printer
        Driver   = $null
        Port     = $false
        PC       = $object.device
        Comment  = $null
        Completed = $false
        

    }

    if ($object.Printer -match "HP") {
        
        $check_port = ($printers_VMCTXPRN | where { $_.name -match $object.printer }).Portname -match $object.Printer
        $check_device = ($printers_VMCTXPRN | where { $_.name -match $object.printer }).Name -match $object.Printer

        if ($check_port -eq $true) {
            $obj_output_printers.Port = $true
            Write-Host "$($object.printer): This port has already been added."
            }
        if ($check_port -eq $false){
            Add-PrinterPort -ComputerName VMCTXPRN -PrinterHostAddress "$($object.printer)" -Name "$($object.printer)"
            $obj_output_printers.Port = $true
            }
        
        if ($check_device -eq $true){
            $obj_output_printers.Driver = "HP Universal Printing PCL 6 (v6.8.0)"
            $obj_output_printers.Comment = "MED PARK 2"
            Write-Host "$($object.printer): This printer has already been added."
            $obj_output_printers.Completed = $true
            }

        if ($check_device -eq $false){

            $obj_output_printers.Driver = "HP Universal Printing PCL 6 (v6.8.0)"
            $obj_output_printers.Comment = "MED PARK 2"
            Add-Printer -ComputerName VMCTXPRN -DriverName $obj_output_printers.Driver -Comment $obj_output_printers.Comment -PortName "$($object.Printer)" -Name "$($object.printer)" -ShareName "$($object.printer)"
            $obj_output_printers.Completed = $true
            }
          }
        

    if ($object.Printer -match "XR") {

       $check_port = ($printers_VMCTXPRN | where { $_.name -match $object.printer }).Portname -match $object.Printer
       $check_device = ($printers_VMCTXPRN | where { $_.name -match $object.printer }).Name -match $object.Printer

        if ($check_port -eq $true) {
            $obj_output_printers.Port = $true
            Write-Host "$($object.printer): This port has already been added."
            }

        if ($check_port -eq $false){
            Add-PrinterPort -ComputerName VMCTXPRN -PrinterHostAddress "$($object.printer)" -Name "$($object.printer)"
            $obj_output_printers.Port = $true
            }
        
        if ($check_device -eq $true){
            Write-Host "$($object.printer): This printer has already been added."
            $obj_output_printers.Driver = "Xerox GPD PCL6 V3.9.520.6.0"
            $obj_output_printers.Comment = "MED PARK 2"
            $obj_output_printers.Completed = $true
            }

        if ($check_device -eq $false){
            $obj_output_printers.Driver = "Xerox GPD PCL6 V3.9.520.6.0"
            $obj_output_printers.Comment = "MED PARK 2"
            Add-Printer -ComputerName VMCTXPRN -DriverName $obj_output_printers.Driver -Comment $obj_output_printers.Comment -PortName "$($object.Printer)" -Name "$($object.printer)" -ShareName "$($object.printer)"
            $obj_output_printers.Completed = $true
            }
          }

          $col_printers.Add($obj_output_printers)
        }

# BUILDING PRINTER CONNECTIONS - SQL 
foreach ($object in $import_printers){

$con_printer = "\\vmctxprn\$($object.printer)"

    $sql_output = [PSCustomObject] @{
    
         Device      = $object.device
         Printer     = $object.Printer
         Connection  = $con_printer
         True        = $null
         Completed   = $false
        
    }


$con_printer = "\\vmctxprn\$printerconnection"

if ($sql){}
$isDefault = "$true"


$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
$mySQLCon.Open()
$qryUpdate = @"
update [ITS_SDW].[dbo].[NGHS_Virtual_Printer_Mapping]
Set printer = '$($newprinter)',isDefault = '$($isDefault)'
Where ClientName = '$($object.device)' and Printer = '$($oldPrinter)'
"@
$new_connection = $mySQLCon.exec($qryUpdate)
$mySQLCon.Close()

}

