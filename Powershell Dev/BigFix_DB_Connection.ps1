#Written by Curtis Menard
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


# Create new SQL connection
$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
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