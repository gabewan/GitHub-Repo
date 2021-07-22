#Create an ArrayList object that will display your headers and such.
$DiplayingObject = New-Object System.Collections.ArrayList

#Just getting a list of object to go through as an example.
$ListOfObjects = Get-ADComputer -filter { Name -like '101IRR*' }

#Go through them
foreach ($ComputerADObject in $ListOfObjects)
{
	#Do some things, create some variables.
	$ComputerName = $ComputerADObject.Name
	
	$ComputerDN = ($ComputerADObject.DistinguishedName.Split(',') | where{ $_ -like "OU=*" }).Replace('OU=', '')
	[array]::Reverse($ComputerDN)
	$ComputerOU = $ComputerDN -join '/'
	
	$ComputerOnline = Test-Connection -ComputerName $ComputerADObject.DNSHostName -Count 1 -Quiet
	
	#Create a blank variable, then "Select" the Headers you want to create, you can name them whatever you want.
	$ObjectToAdd = "" | Select-Object "Header1", "Header2", "Header3"
	
	#Add item under the first header.
	$ObjectToAdd.Header1 = $ComputerName
	
	#Add item under the second header.
	$ObjectToAdd.Header2 = $ComputerOU
	
	#Add item under the third header.
	$ObjectToAdd.Header3 = $ComputerOnline
	
	#Add this entire object to the ArrayList object you made at the beginning.
	$DiplayingObject.Add($ObjectToAdd)
}

#Display IT!
$DiplayingObject