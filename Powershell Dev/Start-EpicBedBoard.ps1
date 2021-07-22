<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.143
	 Created on:   	9/1/2017 9:34 AM
	 Created by:   	cumenard
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
#============================================================================================================
# Open a connection to a SQL DB
#============================================================================================================
Function Open-Database {
	Param (
		[Parameter(Mandatory = $true)]$SQLInstance,
		[Parameter(Mandatory = $true)]$DatabaseName
	)
	
	[void][Reflection.Assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	
	$ConnectionString = "Integrated Security=True;User ID=;Password=;Initial Catalog=$DatabaseName;Data Source=$SQLInstance;"
	$Connection = New-Object System.Data.SQLClient.SQLConnection($ConnectionString)
	
	try {
		$Connection.Open()
	}
	catch {
		exit
	}
	
	Return $Connection
	
}

#============================================================================================================

#============================================================================================================
# Usage:
# $DBCon = Open-Database "SQLServer" "DBName"
# $Data = Query-Database $DBCon "Select * from Something"
# Close-Database $DBCon
#============================================================================================================

Function Query-Database {
	Param (
		[Parameter(Mandatory = $true)]$SQLConnection,
		[Parameter(Mandatory = $true)]$SQLQuery
	)
	
	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
	$SqlCmd.CommandText = $SqlQuery
	$SqlCmd.Connection = $SqlConnection
	$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
	$SqlAdapter.SelectCommand = $SqlCmd
	$DataSet = New-Object System.Data.DataSet
	
	Try {
		$SqlAdapter.Fill($DataSet) | Out-Null
	}
	Catch {
		# Write-Log $logfile "Table query failed: $($error)"
		# Throw $($error) # Should throw an exception, but may not be exactly what is needed
		# all the time.
	}
	
	Return $DataSet.Tables[0]
}

#=============================================================================================================


#=============================================================================================================
# Usage:
# $DBCon = Open-Database "SQLServer\instance" "DBName"
# $Data = Exec-SQLCommand $DBCon "Non query statement ie. Truncate, Insert, Delete"
# Close-Database $DBCon
#=============================================================================================================
Function Exec-SQLCommand {
	Param (
		[Parameter(Mandatory = $true)]$SQLConnection,
		[Parameter(Mandatory = $true)]$SQLQuery
	)
	
	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
	$SqlCmd.CommandText = $SqlQuery
	$SqlCmd.CommandTimeout = 300
	$SqlCmd.Connection = $SqlConnection
	
	Try {
		$SqlCmd.ExecuteNonQuery()
	}
	Catch {
		#. Write-Log $LogFile "SQL Command failed: $($error[0])"
		# Throw $($error) # Should throw an exception, but may not be exactly what is needed
		# all the time.
	}
	
}
#=============================================================================================================

#============================================================================================================
# Usage: 
# $DBCon = Open-Database $BigFix_KBSProd_SQLServer $BigFix_KBSProd_DBName
# Do some stuff
# Close-Database $DBCon
#============================================================================================================
Function Close-Database {
	Param (
		[Parameter(Mandatory = $true)]$SQLConnection
	)
	
	$SQLConnection.Close()
	
}

#============================================================================================================
$ClientName = $env:COMPUTERNAME

# Query the SQL DB for the printers assigned to this client
$SystemQuery = @"
SELECT * 
FROM [ITS_SDW].[dbo].[Bed_Board_Config]
Where ClientName = '$ClientName'
Order By EpicAccount
"@

# SQL Server and DB
$SQLServer = "vmdbitssql01"
$SQLDB = "ITS_SDW"

# Run the DB query and pull back the printers in a table
$SQLConnection = Open-Database -SQLInstance $SQLServer -DatabaseName $SQLDB

# Get the users associated with this Board
$UserList = Query-Database -SQLConnection $SQLConnection -Sqlquery $SystemQuery

if ($Userlist) {

	# Loop through users and start up Epic Warp Drive
	foreach ($User in $UserList) {
		#Start a Warp Drive session
		start-process -filepath "c:\Program Files (x86)\Epic\v8.3\Shared Files\EpicEPoolMgrLogin83.exe" -ArgumentList "UserId=$($User.EpicAccount) Password=$($User.EpicPwd) AutoStart=true Hideonconnect=true"
		sleep -s 10
	}
		
}

