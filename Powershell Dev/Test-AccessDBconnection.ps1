<# HEADER
/*=====================================================================
Program Name            : Query-Access.ps1
Purpose                 : Execute query against Access Database
Powershell Version:     : v2.0
Input Data              : N/A
Output Data             : N/A
Originally Written by   : Scott Bass
Date                    : 26SEP2013
Program Version #       : 1.0
=======================================================================
Modification History    :
=====================================================================*/
/*---------------------------------------------------------------------
THIS SCRIPT MUST RUN UNDER x86 (32-bit) POWERSHELL SINCE WE ARE USING
32-BIT MICROSOFT OFFICE.  ONLY THE x86 OLEDB PROVIDER IS INSTALLED!!!
---------------------------------------------------------------------*/
#>

<#
.SYNOPSIS
Query Access Database
.DESCRIPTION
Execute a query against an Access Database
.PARAMETER  SQLQuery
SQL Query to execute
.PARAMETER  Path
Path to Access Database
.PARAMETER  Csv
Output as CSV?  If no, the Dataset Table object is returned to the pipeline
.PARAMETER  Whatif
Echos the SQL query information without actually executing it.
.PARAMETER  Confirm
Asks for confirmation before actually executing the query.
.PARAMETER  Verbose
Prints the SQL query to the console window as it executes it.
.EXAMPLE
.\Query-Access.ps1 "Y:\HBM\_HBM-Common\CDMP\CDMP Management.accdb" "select * from coach" -csv
Description
-----------
Queries the specified Access database with the specified query, outputting data as CSV
.EXAMPLE
.\Query-Access.ps1 -path "Y:\HBM\_HBM-Common\CDMP\CDMP Management.accdb" -query "select * from coach" -csv:$false
Description
-----------
Queries the specified Access database with the specified query, 
returning the Object Table to the pipeline
#>

#region Parameters




$path = "\\hqsbvnxfile1\its\DATA\DesktopSupport\Map Data\Database1.accdb"
$ErrorActionPreference = "Stop"

#$adOpenStatic = 3
#$adLockOptimistic = 3

$SqlConnection = New-Object System.Data.OleDb.OleDbConnection
$SqlConnection.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source=$path"
$SqlCmd = New-Object System.Data.OleDb.OleDbCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.OleDb.OleDbDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
#$nRecs = $SqlAdapter.Fill($DataSet)
#$nRecs | Out-Null

# Populate Hash Table
$objTable = $DataSet.Tables[0]



$Dataset.Open("Select * from Devices")
# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzlqHf3dqA0Rc4LccuqybaXse
# M+SgggMnMIIDIzCCAgugAwIBAgIQQLH43sgH4IFIu94Hs10bXjANBgkqhkiG9w0B
# AQsFADAbMRkwFwYDVQQDDBBncmxld2lzQG5naHMuY29tMB4XDTE5MDIxODE2MTcz
# N1oXDTIwMDIxODE2MzczN1owGzEZMBcGA1UEAwwQZ3JsZXdpc0BuZ2hzLmNvbTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALW1WUSF3b+IwTQ7gk0Wx5Ap
# 12KUN8LgBQo7IdtDz6HDG/d3EU2gj27qjktOJI9ChnDdp4G5/8hNVPb9s2eIh5ae
# 1Cc/RHwFLu3WlIiEs5p7xbHprqR4gg8J3eEjHcY2FJxf+1NyLeov3CLWYRXfHgef
# ZqI0WJ1PEO6Jv5/VVWw0oMp2Od04PfH/rymHRh0yFSueOmfO/zxKcSM9/21C/n1Y
# B8ffpznvlY0smaikTkC7dubkX6GHU64ZDI69esh/KvPyX0m6e08130aIbaN3me0i
# lNmlBBqA52mVSIarDzY50HQHHF25zqgWqwYs0RSrwO20xwR33l2z7O3MpKZHGgkC
# AwEAAaNjMGEwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBsG
# A1UdEQQUMBKCEGdybGV3aXNAbmdocy5jb20wHQYDVR0OBBYEFB3t05KWOpdR18AN
# FF5Q6CIVBV94MA0GCSqGSIb3DQEBCwUAA4IBAQCU54GYx7ycvM7LHjgchGu2Gwak
# rY2AFJndoGyWB2D/B+uBpI3RxQKWZXaeEpKyUxGWfiFKyHLBfesNyCawzBIzkXxR
# QFZkS532tq9snNHmrX+dhw3cH5/ww/VwWyrvLq19I4wCS+1BTCwJUbetigDv+zlT
# bf/wXP5h13OC6clYRbTq0mTglqYXBlDVjFOwkI6MpvXwoKarggJ1N71HA2TqQpWU
# TA+6WgfEPiZDzpLig5ri6wSu1oVVq+YhP1yPDq+2OQ03SM04GdaUkWVkZnGqS6Ev
# d34IsRreZ6jF5LvSolXkXXfK9/1V11928ne/51iwjgMn7R5V2rhR+EnME6cvMYIB
# 0DCCAcwCAQEwLzAbMRkwFwYDVQQDDBBncmxld2lzQG5naHMuY29tAhBAsfjeyAfg
# gUi73gezXRteMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT8fGUP3JH47zKXsaMk8lyC8OysqzAN
# BgkqhkiG9w0BAQEFAASCAQADYZggbkDGn2HkL49eBA+Ruo7aDB3AOIr4KUzSlyNs
# bjAaWIAhTeVMquOnYTy8mnp17fec1WiRpGU5MlBncpGsIwK/PDXD/qxJrueO0041
# a7ZT1qgKpOrqtWGhJJD5cRpc0IiMj5al6Z06MT6HvykXyrehec2tqUWpmiKnlFl0
# R2R9laPn4LiX973GgYU3+eidYVCMI0WiSmhksZVvDrnCTYKBgLQ3Er7Me5r7DRFO
# XlL2oEToTGjl/9WotbrQz6Zm2P9zSLN3U+09DQWi9tOOjRWOWakcSwyQzWzHDLiz
# iodCUWjHj9quRGwJxyc+vN62FKGlKmaRjelhM89ERLOt
# SIG # End signature block
