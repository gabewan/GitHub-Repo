$site = "Braselton Campus - NICU"

$mySQLCon = [MSSQL]::new("vmdbitssql01", "ITS_SDW")
$mySQLCon.Open()
$qryWED_Path = 'SELECT [ComputerID]
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
$WED_Path = $mySQLCon.query($qryWED_Path)

#Thin Client Database - $ThinConnections_BFDB

$qryThinConnections_BFDB = @"
SELECT [ClientName]
		,[Printer]
		,[isDefault]
		,[PriKey]
FROM [ITS_SDW].[dbo].[NGHS_Virtual_Printer_Mapping]
"@
$ThinConnections_BFDB = $mySQLCon.Query($qryThinConnections_BFDB)

#Facility Database - $facilities 

$qrySiteList = @"
SELECT TOP (1000) [facility]
		,[buildingcode]
		,[department]
FROM [ITS_SDW].[dbo].[NGHS_Facility_Codes] 
"@
$SiteList = $mySQLCon.Query($qrySiteList)
	
#Printer Database - $Printers_BFDB
$qryPrinters_BFDB = @"
SELECT [PrintServer]
      ,[PrinterName]
      ,[DriverName]
      ,[QueueName]
      ,[PortName]
      ,[HostAddress]
      ,[ShareName]
  FROM [ITS_SDW].[dbo].[NGHS_Windows_Network_Printers]
"@
$Printers_BFDB = $mySQLCon.Query($qryPrinters_BFDB)

	#$tabpage1.Text = "PRINTERS"
	#$tabpage2.Text = "COMPUTERS"
	#$Username.text = $env:USERNAME

	#$SiteSelection_Label.Text = $Site
	$SiteCode = ($SiteList | where { $_.facility -eq "$Site" }).buildingcode
	$SiteDepartment = ($SiteList | where { $_.facility -eq "$Site" }).department
	$SiteSelection = "$SiteCode" + "$SiteDepartment"
	
	#Device Query: Grabs the devices from SQL Query
	$Computer_Combo = ($WED_Path | where {$_.ComputerName -like "$SiteSelection*"}).ComputerName
	$ThinClient_Combo = $ThinConnections_BFDB | where { $_.ClientName -like "$SiteSelection*"}
	
	#$Printers = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\printers_VMCTXPRN.csv"
	$VMCTXPRN_Printers = $Printers_BFDB | where { $_.PrintServer -eq "vmctxprn" }
	$WINPRN_Printers = $Printers_BFDB | where { $_.PrintServer -eq "winprn" }
	$VBINPRINT_Printers = $Printers_BFDB | where { $_.PrintServer -eq "vbinprint" }
	
	#$ImportFile = Import-Csv '\\hqsbvnxfile1\global\grlewis\Script_Deployment\facilities.csv'
	
	#$SelectedFacility = "$Site"
	#portname - hostaddress
	
	#$Combo = "$(($SiteList | where { $_.facility -eq $Site }).buildingcode)$(($SiteList | where { $_.facility -eq $Site}).department)"
	
	#VMCTXPRN - Facility Search
	$CSubnets_VMCTXPRN = ($VMCTXPRN_Printers | where { $_.printername -match "^$($SiteSelection)"}).portname | select -Unique
	$VMCTXPRN_Search = $VMCTXPRN_Printers | where {$CSubnets_VMCTXPRN -contains $_.portname }
	
	$CSubnets_WINPRN = ($WINPRN_Printers | where { $_.printername -match "^$($SiteSelection)" }).portname # | select -Unique
	$WINPRN_Search = $WINPRN_Printers | where {$CSubnets_WINPRN -contains $_.portname }
	
	$CSubnets_VBINPRINT = ($VBINPRINT_Printers | where { $_.printername -match "^$($SiteSelection)" }).portname | select -Unique
	$VBINPRINT_Search = $VBINPRINT_Printers | where { $CSubnets_VBINPRINT -contains $_.portname }

#no more SQL work needed at this point
$mySQLCon.Close()

$TC = "214HC4TC007"
$TC_Array = ($ThinConnections_BFDB | where {$_.Clientname -eq "$tc"}).Printer