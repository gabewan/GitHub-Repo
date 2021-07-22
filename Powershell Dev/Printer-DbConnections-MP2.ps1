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
$import_printers = Import-Csv -Path C:\users\grlewis\desktop\delete.csv 
$col_sql = [System.Collections.Generic.List[System.Object]]::new()

# BUILDING PRINTER CONNECTIONS - SQL 
foreach ($object in $import_printers){


    $sql_output = [PSCustomObject] @{
    
         Device      = $object.pc
         Printer     = "\\vmctxprn\$($object.Printer)"
         Connection  = $con_printer
         isDefault   = $true
         Completed   = $false
        
    }

$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
$mySQLCon.Open()
$qryInsert= @"
INSERT INTO [ITS_SDW].[dbo].[NGHS_Virtual_Printer_Mapping]
      ([ClientName]
      ,[Printer]
      ,[isDefault]
       )
 VALUES
     ('$($object.PC)',
       '$($sql_output.Printer)',
       '$($sql_output.isDefault)')
"@
$new_connection = $mySQLCon.exec($qryInsert)

$col_sql.Add($sql_output)
}
$mySQLCon.Close()


$col_sql | Export-Csv 'C:\temp\MP2_ConPrinters.csv' -Force