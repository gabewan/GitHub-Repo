	$WINPRN_INFO = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\printers_winprn.csv"
	$ImportFile = Import-Csv '\\hqsbvnxfile1\global\grlewis\Script_Deployment\facilities.csv'
	$SelectedFacility = "Main - C3A - RGHC"
	$Combo = "$(($ImportFile | where{ $_.facility -eq $SelectedFacility }).buildingcode)$(($ImportFile | where{ $_.facility -eq $SelectedFacility }).department)"
    $WPCOMBO = ( $WINPRN_INFO | where{ $_.Name -match "^$($Combo)" }).Subnet | select -Unique
    $WPPrinterSubs = $WINPRN_INFO | where {$Combo -contains $_.Subnet}
    $WPComboPrinters = New-Object System.Collections.ArrayList
    foreach ($PrinterObject in $WPPrinterSubs) {
		<#if ($PrinterObject.Name -match '^\d{3}\w{3}(XR|HP)\d{3}$')
			{
				if ($PrinterObject.Name -match "^$($Combo)")
				{
					[void]$ComboPrinters.Add($PrinterObject)
				}
				else
				{
					continue
				}
			}
			else
			{
				[void]$ComboPrinters.Add($PrinterObject)
			} #>
        Write-Host $PrinterObject.Name


	}


