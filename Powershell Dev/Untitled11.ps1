#Written by Curtis Menard
#Badly edited by Gabe Lewis
#============================================================================================================
# MSSQL Class
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
#============================================================================================================
# FullClient Table
$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
$mySQLCon.Open() 
$query = 'SELECT [ComputerID]
,[ComputerName]
,[OS]
,[DeviceType]
,[UserName]
,[IPAddress]
,[InstalledApplications]
,[MACAddress]
,[LastReportTime]
,[Uptime]
FROM [ITS_SDW].[dbo].[BigFix_Workstation_List]'
$results = $mySQLCon.query($query)
$mySQLCon.Close()

#ThinClient Printer Connection Table
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
$mySQLCon.Close()

#Facility Table
$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
$mySQLCon.Open() 
$query = @"
SELECT TOP (1000) [facility]
      ,[buildingcode]
      ,[department]
  FROM [ITS_SDW].[dbo].[NGHS_Facility_Codes] 
"@
$facility_results = $mySQLCon.Query($query)
$mySQLCon.Close()




  #Printer Table
$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
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
$printer_results = $mySQLCon.Query($query)
$mySQLCon.Close()


