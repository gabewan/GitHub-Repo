$ComputerConfirmed = $Null
$NameInput = $Null
$ComputerADObject = $Null
$Online = $Null
$sidpatthern = $Null
$UserProfiles = $Null
$AllUsers = $Null

while ($ComputerConfirmed -ne $true) 
{
    $NameInput = Read-Host "Enter Computername"
    try 
    {
        $ComputerADObject = Get-ADComputer -Identity $NameInput
    }
    catch 
    {
        Write-Host "Unable to find computer in Active Directory. Try another?"
    }

    if (Test-Connection -ComputerName $ComputerADObject.DNSHostName -Count 1 -Quiet)
    {
        $Online = $true
        $ComputerConfirmed = $true
        Write-Host "Computer["$ComputerADObject.Name"] is online"
        $ComputerName = $ComputerADObject.Name
    }
    else
    {
        $Online = $false
        $ComputerConfirmed = $false
        Write-Host "Computer is offline; try another?"
    }
}

$sidpattern= 'S-1-5-21-\d+-\d+\-\d+\-\d+'
$ExemptSIDs = "S-1-5-21-3935014889-4041342687-1980156064-1002",
"S-1-5-21-3935014889-4041342687-1980156064-1001"
$UserProfiles = New-Object System.Collections.ArrayList
$AllUsers = Get-WmiObject -Class Win32_UserProfile -ComputerName $ComputerName |`
    Where-Object `
    {`
        ($_.SID -match $sidpattern) -and ($_.LocalPath -notlike "*Administrator*")`
    }

foreach ($UserObj in $AllUsers)
{
    if($ExemptSIDs -contains $UserObj.SID){
        "Exempt SID found"
        continue
    }
    if ((Get-ADUser -Identity $UserObj.SID -ErrorAction SilentlyContinue) -ne $null)
    {
        $userSID = $UserOBj.SID
        $UserADObj = Get-ADUser -Identity $UserObj.SID
        $UserProfObj = "" | select Name, Username, SID, UserProfilePath, UserProfileSize, Printers
        $UserProfObj.Name = $UserADObj.Name
        $UserProfObj.Username = $UserADObj.SamAccountName
        $UserProfObj.SID = $userSID
        $UserProfObj.UserProfilePath = $UserObj.LocalPath
        
        $UserProfilePath = ($UserObj.LocalPath).replace('C:\',"\\$computerName\C`$\")
        $UserProfileSize_B = (Get-ChildItem -Recurse -Path $UserProfilePath | Measure-Object -Property Length -Sum).Sum
        $UserProfileSize_MB = [Math]::Round(($UserProfileSize_B / 1MB), 2)
        $UserProfObj.UserProfileSize = "$UserProfileSize_MB MB"

        if(Test-Path -Path "$userprofilepath\NTUSER.Dat"){
            $prn_command1 = "reg load `"HKU\$userSID`" `"$UserProfilePath\NTUSER.DAT`""
            $prn_command2 = "reg query HKU\$userSID\Printers\Connections"
            $prn_command3 = "reg unload HKU\$userSID"
            $Psexec_PRN_Output = psexec \\$computername cmd /c "$prn_command1 && $prn_command2 && $prn_command3"
            $oArr = ($Psexec_PRN_Output -split ('`r'))
            $pline = $oArr | where{$_ -like "*\Printers\Connections\,,*"}
            $UserProfObj.Printers = ($pline.split('\') | where{$_ -like ',,*'}).replace(',','\')

            $prn_command1, $prn_command2, $prn_command3, $Psexec_PRN_Output, $oArr, $pline = $null
        }
    }
    else
    {
        continue
    }
    $UserProfiles.Add($UserProfObj)
}


$UserProfiles | Format-Table