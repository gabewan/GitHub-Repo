#SiteLoads - Facility/Department/Codes and PrintServer_Report
	$SiteList = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\GitKraken\Application-Repository\Application-Repository\Grlewis Scripts\Reports\facilities.csv"
	$Printers = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\GitKraken\Application-Repository\Application-Repository\Grlewis Scripts\Reports\printers.csv"
	$Computers = "" 
	
	$SiteSelection_Label.Text = $Site
	$SiteCode = ($SiteList | where { $_.facility -eq "$Site" }).buildingcode
	$SiteDepartment = ($SiteList | where { $_.facility -eq "$Site" }).department
	$SiteSelection = $SiteCode + $SiteDepartment
	
	#ErrorHandeling - Site Codes cannot be empty, if empty, it will email with incorrect codes. Need Build - Yes
	
	if ($SiteDepartment -eq $null) { $SiteCode_Label.Text = "INCORRECT SITE CODE" }
	if ($SiteDepartment -ne $null -and $SiteCode -ne $null) { $SiteCode_Label.Text = $SiteSelection }
	
	#Old Printer Ports
	if ($SiteCode -eq $null) { $SiteCode_Label.Text = "INCORRECT SITE CODE" }
	$Get_OldPorts = ($Printers | where { $_.Name -like "$SiteSelection*" }).PortName
	$GPO_Trim = $Get_OldPorts | Sort-Object | select -first 1 
	$Subnet_Ports = $Gpo_trim.Remove($Gpo_trim.LastIndexOf('.'))
	$Get_OldPorts_Subnet = ($Printers | where { $_.Portname -like "$Subnet_Ports*" }).Portname
	
	if ($Subnet_Ports.Split(".")[2] % 2 -eq 0)
	{
		$Sub = $Subnet_Ports.Split(".")[2]
		$Sub2 = [int]$Subnet_Ports.Split(".")[2] + 1
		$Subnet_Ports_Odd = $Subnet_Ports.Replace($Sub, $Sub2)
	}
	
	$Get_OldPortsOdd_Subnet = ($Printers | where { $_.Portname -like "$Subnet_Ports_Odd*" }).Portname
	
	$OldPorts = $Get_OldPorts + $Get_OldPorts_Subnet + $Get_OldPortsOdd_Subnet | Sort-Object
	$OldPort_List.DataSource = $OldPorts
	
	#Old Printers
	$OldPrinter_Objects = New-Object System.Collections.ArrayList
	
	foreach ($Port in $OldPorts) {
		$TempObjects_Old = "" | Select-Object 'Printer'
		$Printer = ($Printers | where { $_.PortName -eq "$Port" }).Name
		$TempObjects_Old.Printer = $Printer
		$OldPrinter_Objects.Add($TempObjects_Old) | Out-Null
	}
	
	$Get_OldPrinters = ($Printers | where { $_.Name -like "$SiteSelection*" }).Name
	$Get_OldPrinters_BadNames = $Printers | where {$_.PortName -match "$OldPorts"}
	$OldPrinter_List.DataSource = $OldPrinter_Objects.Printer | Sort-Object
	
	