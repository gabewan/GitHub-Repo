$ImportFile = Import-Csv '\\hqsbvnxfile1\global\grlewis\Script_Deployment\facilities.csv'
$NameFormatRegex = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'
#$REG_EX_Filter_Old = '^([a-zA-Z0-9]{6})([1-2]{1})$' 
$CompObjects = New-Object System.Collections.ArrayList
$AllComputers = Get-ADComputer -Filter * -SearchBase 'DC=NGHS,DC=COM' | 
    Where-Object{
        $_.DistinguishedName -notlike "*VDI*" -and $_.DistinguishedName -notlike "*VM*" -and $_.DistinguishedName -notlike "*HQ*" -and $_.DistinguishedName -notlike "*VBAUD*"
    }  | 
    Sort-Object -Property Name 


Get-Job | Remove-Job -Force

foreach($ComputerObj in $AllComputers){
    $ComputerADName = $ComputerObj.Name
    if($ComputerADName -match $NameFormatRegex){
        $running = @(Get-Job | Where{$_.State -eq 'Running'})    
        while($running.Count -ge 40){
            Get-Job | Wait-Job -Any | Out-Null
            $running = @(Get-Job | Where{$_.State -eq 'Running'})
        }

        Start-Job -Name $ComputerADName -ArgumentList $ComputerADName {
            if(Test-Connection -ComputerName $args[0] -Count 1 -Quiet){
                (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $args[0] -Property Caption).Caption
            } else {
                Write-Output 'Offline'
            }
        } 
    } else {
        continue
    }
}

Get-Job * | Wait-Job | Out-Null

foreach ($Job in (Get-Job)) {
    $JobName = ($Job.Name).ToString()

    $ComputerName = $JobName
    $TempObject = "" | Select-Object 'ComputerName', 'BuildingCode', 'DepartmentCode', 'Facility', 'OperatingSystem'
    if($ComputerName -match $NameFormatRegex){
        $TempObject.Facility = ($ImportFile | Where-Object {$_.BuildingCode -eq $matches.BCode -and $_.Department -eq $matches.dept}).facility
        $TempObject.ComputerName = $ComputerName
        $TempObject.BuildingCode = $Matches.bcode
        $TempObject.DepartmentCode = $Matches.dept
        if($TempObject.Facility -eq $null){
            $TempObject.Facility = "Unknown combo - " + $TempObject.BuildingCode + $TempObject.DepartmentCode
        }

    $Results = Receive-Job $Job
    $TempObject.OperatingSystem = $Results.ToString()
    $CompObjects.Add($TempObject) | Out-Null
    } else {
        continue
    }
}

$CompObjects | sort-object computername | Export-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Win10Migration_RAW.csv" -Force -NoTypeInformation

$excel = New-Object -ComObject excel.application
$excel.visible = $false

$outputpath = '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows 10 Migration.xlsx'

$workbook = $excel.Workbooks.Add()
$W10 = $workbook.Worksheets.Item(1)
$W10.Name = "Windows10Migration"
$i = 2

$W10.Cells.Item(1,1).Interior.ColorIndex = 35
$W10.Cells.Item(1,2).Interior.ColorIndex = 35
$W10.Cells.Item(1,3).Interior.ColorIndex = 35
$W10.Cells.Item(1,4).Interior.ColorIndex = 35
$W10.Cells.Item(1,5).Interior.ColorIndex = 35

$W10.Cells.Item(1,1).Font.Bold=$True
$W10.Cells.Item(1,2).Font.Bold=$True
$W10.Cells.Item(1,3).Font.Bold=$True
$W10.Cells.Item(1,4).Font.Bold=$True
$W10.Cells.Item(1,5).Font.Bold=$True

$W10.Cells.Item(1,1).Font.Size = 12
$W10.Cells.Item(1,2).Font.Size = 12
$W10.Cells.Item(1,3).Font.Size = 12
$W10.Cells.Item(1,4).Font.Size = 12
$W10.Cells.Item(1,5).Font.Size = 12

$w10.Cells.Item(1,1)="Computername"
$W10.Cells.Item(1,2)="BuildingCode"
$W10.Cells.Item(1,3)="DepartmentCode"
$W10.Cells.Item(1,4)="Facility"
$W10.Cells.Item(1,5)="OperatingSystem"

$records = Import-Csv "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Win10Migration_RAW.csv"

Remove-Item '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows 10 Migration.xlsx' -Force

foreach($record in $records){
$excel.cells.item($i,1)=$record.Computername
$excel.cells.item($i,2)=$record.BuildingCode
$excel.cells.item($i,3)=$record.DepartmentCode
$excel.cells.item($i,4)=$record.Facility
$excel.cells.item($i,5)=$record.OperatingSystem
$i++
}

$UsedRange = $W10.UsedRange
$UsedRange.EntireColumn.AutoFit() | Out-Null

$workbook.SaveAs($outputpath)
$excel.Quit()

$FS = (Get-ADGroupMember "CN=Field Services,CN=Users,DC=nghs,DC=com" | select name ).name
 $FS_Total =   foreach ($Member in $FS){
         if ($Member -ne 'Jim Harry'){
             if ($Member -ne 'Mario Benjamin'){
                 if ($Member -ne 'Robert Johnson'){
                    Get-ADGroupMember "CN=$Member,CN=Users,DC=nghs,DC=com" | select samaccountname
                       
                      }
                     }
                    }
                   }
$FS_Emails =  Foreach($Name in $FS_Total.samaccountname){
    (get-aduser $Name -Properties * | select mail).mail
  }

$Msg_Count = Import-Csv '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Win10Migration_RAW.csv' 
$MailTo = 'gabe.lewis@nghs.com'#$FS_Emails
$MailFrom = "Windows 10 Migration<gabe.lewis@nghs.com>"
$MailServer = "mail.nghs.com"
$Subject = "Inventory - Windows 10"

$Win10Ent_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows 10 Enterprise"}
$Win10ELTSB_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows 10 Enterprise 2016 LTSB"}
$Win10Pro_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows 10 Pro"}
$Win7Ent_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows 7 Enterprise "}
$Win7EntN_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows 7 Enterprise N "} 
$Win7Pro_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows 7 Professional "} 
$Win8Pro_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows 8.1 Pro"} 
$WinEmb_Count = $Msg_Count | where {$_.OperatingSystem -eq "Microsoft Windows Embedded Standard "} 
$Win10Combined = $Msg_Count | Where {$_.OperatingSystem -like "*Windows 10*"}

$Win10Ent_Counted = $Win10Ent_Count.Count 
$Win10ELTSB_Counted = $Win10ELTSB_Count.Count
$Win10Pro_Counted = $Win10Pro_Count.Count
$Win7Ent_Counted = $Win7Ent_Count.Count
$Win7EntN_Counted = $Win7EntN_Count.Count
$Win7Pro_Counted = $Win7Pro_Count.Count
$Win8Pro_Counted = $Win8Pro_Count.Count
$WinEmb_Counted = $WinEmb_Count.Count

$North_Array = New-Object System.Collections.ArrayList
$South_Array = New-Object System.Collections.ArrayList
$Central_Array = New-Object System.Collections.ArrayList
$North_Comp_Array = New-Object System.Collections.ArrayList
$South_Comp_Array = New-Object System.Collections.ArrayList
$Central_Comp_Array = New-Object System.Collections.ArrayList


$North_Members = @(
'208NGP',
'211TCC',
'211LLP',
'216NGP',
'216GYN',
'216SAS',
'216URG',
'226NGP',
'226PED',
'230NGP',
'231NGP',
'231THC',
'234NGP',
'236URG',
'237THC',
'242THC',
'243THC',
'249THC',
'250THC',
'250ADM',
'250FAM',
'250TIM',
'250INT',
'250LAB',
'250MAC',
'250ORT',
'250PED',
'250PDW',
'250IMC',
'251ADM',
'251OBG',
'251IMC',
'251FAM',
'251URO',
'253FAM',
'253LAB',
'253IMC',
'253PED',
'254SUR',
'255PED',
'256PED',
'405EMS',
'206GYN',
'230RHB',
'250FSN',
'250IMG',
'251FSN'
'251ITS'
'251LAB'
'251REC'
'253ADM'
'253REC'
'601FSN'
'601LMK'
)
$South_Members = @(
'111B1E'
'111B1W'
'111B2E'
'111B2W'
'111B3W'
'111BOR'
'111BPH'
'111CAR'
'111CAT'
'111CDI'
'111CHP'
'111CPR'
'111CSM'
'111DRS'
'111EMS'
'111EVS'
'111FAN'
'111FIN'
'111FSS'
'111ICU'
'111IFC'
'111LAB'
'111LDR'
'111LLP'
'111LRP'
'111MCR'
'111NGG'
'111NIC'
'111POP'
'111PST'
'111RAD'
'111REG'
'111RSP'
'111SPD'
'111VOL'
'112ADM'
'112ARC'
'112BIO'
'112BPH'
'112BSS'
'112CHA'
'112CSM'
'112EMS'
'112EVS'
'112FAN'
'112FIN'
'112HIM'
'112HRD'
'112ICM'
'112ICP'
'112IMC'
'112ITS'
'112LAB'
'112LLP'
'112LOG'
'112MAM'
'112MOB'
'112PAE'
'112PLO'
'112PRS'
'112RAD'
'112RBL'
'112RCV'
'112REG'
'112RSP'
'112VEN'
'112WIN'
'112WND'
'201SUR'
'202HL1'
'202IMC'
'202MED'
'202NGP'
'202SPE'
'202THC'
'202URG'
'203NGP'
'204INT'
'204NGP'
'204OCR'
'205NGP'
'209CTS'
'209MER'
'209NGP'
'209NPY'
'209OBG'
'209ORT'
'209THC'
'209URO'
'210AAB'
'210FAM'
'210HLB'
'210IMC'
'210LST'
'210NEU'
'210NGP'
'210OCR'
'210ONC'
'210PHM'
'210ROM'
'210URG'
'212NGP'
'213NGP'
'217NGP'
'220NGP'
'221NGP'
'221OCC'
'222NGP'
'222THC'
'224NGP'
'229NGP'
'232NGP'
'232PRI'
'232UCD'
'233TCH'
'233THC'
'238NGP'
'239OCC'
'241FP1'
'241FP2'
'241FP3'
'241ORT'
'241PCM'
'241REC'
'241THC'
'245IMC'
'404HIM'
'404LLP'
'404NGP'
'404PAC'
'404RBC'
'404RBL'
'600SUR'
)
$Central_Members = @(
'101ACN'
'101C2A'
'101C2B'
'101C3A'
'101C3B'
'101CHP'
'101CMU'
'101CSM'
'101DST'
'101DTS'
'101EMS'
'101EPR'
'101EVS'
'101FIN'
'101GME'
'101HIM'
'101ICU'
'101IRA'
'101IRP'
'101IRR'
'101ITS'
'101LAB'
'101LIB'
'101LLP'
'101MAT'
'101MOR'
'101MRI'
'101N4G'
'101N5G'
'101N6G'
'101NAC'
'101NCT'
'101NGG'
'101NGP'
'101NOO'
'101NUC'
'101NUS'
'101OPA'
'101PAC'
'101PAS'
'101PFT'
'101PST'
'101RAD'
'101REG'
'101SPD'
'101TMP'
'101TRN'
'101VOL'
'102ACN'
'102CAF'
'102CCR'
'102CDI'
'102CMG'
'102COU'
'102CSM'
'102CST'
'102CSV'
'102DIS'
'102DYL'
'102EAU'
'102EDR'
'102EFG'
'102EMS'
'102EOU'
'102ERD'
'102EVS'
'102FSC'
'102FSV'
'102GME'
'102GNS'
'102GPH'
'102GSV'
'102HIM'
'102HRB'
'102HRD'
'102HRM'
'102IFC'
'102IFS'
'102IMD'
'102INF'
'102INR'
'102IPH'
'102IPM'
'102IRD'
'102IVT'
'102LDR'
'102LW1'
'102MED'
'102NPY'
'102NSA'
'102NYP'
'102OCC'
'102OPS'
'102PAL'
'102PLC'
'102PLO'
'102RCT'
'102REG'
'102RSP'
'102S1B'
'102S2B'
'102S2D'
'102S2E'
'102S3B'
'102S3D'
'102S3E'
'102S4B'
'102S4D'
'102S4E'
'102S5D'
'102S5E'
'102SCC'
'102SEC'
'102SGG'
'102SUR'
'102SWB'
'102TEL'
'102TMP'
'102TRA'
'103LW4'
'103NGP'
'104ICN'
'104LDA'
'104LDG'
'104LDR'
'104LDS'
'104LDT'
'104LRP'
'104REG'
'104RSP'
'104S1C'
'104SNU'
'105ADM'
'105CRD'
'105CTH'
'105LAB'
'105OPG'
'105S5E'
'105SJN'
'105STS'
'106LW1'
'106LW2'
'106LW3'
'106NGP'
'107BAR'
'107EDS'
'107EDU'
'107HSP'
'107ITS'
'107LTC'
'107REH'
'107WOC'
'108FOU'
'108HSP'
'109NHN'
'110EPH'
'110LTC'
'207DIS'
'207GME'
'207GV2'
'207IMG'
'207NGP'
'207OBG'
'207PFT'
'207SPM'
'207URO'
'214CTS'
'214HC1'
'214HC2'
'214HC3'
'214HC4'
'214HCC'
'214HCR'
'214NGP'
'214ORT'
'214THC'
'215AAG'
'219NGP'
'225NGP'
'227RHB'
'228OCM'
'228NGP'
'234RHB'
'244NGP'
'246ITS'
'218NGP'
'223OCM'
'223URG'
'228CPR'
'235GV1'
'235GV2'
'239SLP'
'240NGP'
'240SLP'
'244INF'
'247INF'
'247TRA'
'248THC'
'401FIN'
'401MCA'
'402MCA'
'402PRS'
'406EMS'
'408BPH'
'408GPH'
'408HOL'
'408ITS'
'408LLP'
'408RAD'
'409FOO'
'999FST'
)

foreach ($Object in $Msg_Count){

   $Computer =  $Object.ComputerName 
   $OS = $Object.OperatingSystem
   $Comp_Regex = $Computer.Substring(0,6)

    if ($North_Members -contains $Comp_Regex){
         
         $NorthObjects = "" | Select-Object 'ComputerName'
         $NorthObjects.ComputerName = $Computer
         $North_Array.Add($NorthObjects)      
            
            if ($OS -like "*Windows 10*"){
                
                $North_Comp_Objects = "" | Select-Object 'Computername'
                $North_Comp_Objects.ComputerName = $Computer
                $North_Comp_Array.Add($North_Comp_Objects) } 
                   
    }
    if ($Central_Members -contains $Comp_Regex){
         
         $CentralObjects = "" | Select-Object 'ComputerName'
         $CentralObjects.ComputerName = $Computer
         $Central_Array.Add($CentralObjects)
            
              if ($OS -like "*Windows 10*"){
                
                $Central_Comp_Objects = "" | Select-Object 'Computername'
                $Central_Comp_Objects.ComputerName = $Computer
                $Central_Comp_Array.Add($Central_Comp_Objects)  }
    }
    if ($South_Members -contains $Comp_Regex){
        
        $SouthObjects = "" | Select-Object 'ComputerName'
         $SouthObjects.ComputerName = $Computer
         $South_Array.Add($SouthObjects) 
            
              if ($OS -like "*Windows 10*"){
                
                $South_Comp_Objects = "" | Select-Object 'Computername'
                $South_Comp_Objects.ComputerName = $Computer
                $South_Comp_Array.Add($South_Comp_Objects)  }
    }
 }
#TotalDeviceCount
$South_Array | Export-Csv -Path ("\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\SouthArray_Count_" +(get-date).AddDays(0).ToString("MMddyyy")+".csv")   -Force -NoTypeInformation
$North_Array | Export-Csv -Path ("\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\NorthArray_Count_" +(get-date).AddDays(0).ToString("MMddyyy")+".csv")   -Force -NoTypeInformation
$Central_Array | Export-Csv -Path ("\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\CentralArray_Count_" +(get-date).AddDays(0).ToString("MMddyyy")+".csv")   -Force -NoTypeInformation
#Windows10Count
$South_Comp_Array | Export-Csv -Path ("\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\SouthArray10_Count_" +(get-date).AddDays(0).ToString("MMddyyy")+".csv")   -Force -NoTypeInformation
$North_Comp_Array| Export-Csv -Path ("\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\NorthArray10_Count_" +(get-date).AddDays(0).ToString("MMddyyy")+".csv")   -Force -NoTypeInformation
$Central_Comp_Array | Export-Csv -Path ("\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\CentralArray10_Count_" +(get-date).AddDays(0).ToString("MMddyyy")+".csv")   -Force -NoTypeInformation
#DateFormating: Current Date on mm/dd/yy method. Date2, current date for Subject Header. Date_Mins, is current date minus 1 day
$Date = (get-date).ToString("MMddyyy")
$Date2 = Get-Date
$Date_Minus = (get-date).AddDays(-1).ToString("MMddyyy")
#########################
$SAC = $South_Array.Count
$NAC = $North_Array.Count
$CAC = $Central_Array.Count
$SAC_Comp = $South_Comp_Array.Count
$NAC_Comp = $North_Comp_Array.Count
$CAC_Comp = $Central_Comp_Array.Count

#############################
$South_Check = Get-ChildItem -path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\SouthArray_Count_$Date.csv"
$North_Check = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\NorthArray_Count_$Date.csv"
$Central_Check = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\CentralArray_Count_$Date.csv"
$South_Check_10 = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\CentralArray10_Count_$Date.csv"
$North_Check_10 = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\SouthArray10_Count_$Date.csv"
$Central_Check_10 = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\NorthArray10_Count_$Date.csv"
$South_check2 = $South_check.Name.Substring($South_check.name.Length - 12)
$North_check2 = $North_check.Name.Substring($North_check.name.Length - 12)
$Central_check2 = $Central_check.Name.Substring($Central_Check.name.Length - 12)
$South_Check3 = $South_check2.Substring(0,8)
$North_Check3 = $North_check2.Substring(0,8)
$Central_Check3 = $Central_check2.Substring(0,8)
$South_Check_10_Sub = $South_check.Name.Substring($South_check.name.Length - 12)
$North_Check_10_Sub = $North_check.Name.Substring($North_check.name.Length - 12)
$Central_Check_10_Sub = $Central_check.Name.Substring($Central_Check.name.Length - 12)
$South_Check_10_Sub_Trim = $South_check2.Substring(0,8)
$North_Check_10_Sub_Trim = $North_check2.Substring(0,8)
$Central_Check_10_Sub_Trim = $Central_check2.Substring(0,8)

#################################################
$SouthCheckName2 = $South_Check.Name
$NorthCheckName2 = $North_Check.Name
$CentralCheckName2 = $Central_Check.Name
$SouthPathName_Win10 = $South_Check_10.Name
$NorthPathName_Win10 = $North_Check_10.Name
$CentralPathName_Win10 = $Central_Check_10.Name
$SouthPath = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$SouthCheckName2"
$NorthPath = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$NorthcheckName2"
$CentralPath = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$CentralcheckName2"
$SouthPath10 = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$SouthPathName_Win10"
$NorthPath10 = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$NorthPathName_Win10"
$CentralPath10 = "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$CentralPathName_Win10"

################################################
#RemovalofPreviousLogs

$South_Check_Minus = Get-ChildItem -path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\SouthArray_Count_$Date_Minus.csv"
$North_Check_Minus = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\NorthArray_Count_$Date_Minus.csv"
$Central_Check_Minus = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\CentralArray_Count_$Date_Minus.csv"
$South_Check_10_Minus = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\SouthArray10_Count_$Date_Minus.csv"
$North_Check_10_Minus = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\NorthArray10_Count_$Date_Minus.csv"
$Central_Check_10_Minus = Get-ChildItem -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\CentralArray10_Count_$Date_Minus.csv"
$SCM_Sub = $South_Check_Minus.Name.Substring($South_Check_Minus.name.Length - 12)
$NCM_Sub = $North_Check_Minus.Name.Substring($North_Check_Minus.name.Length - 12)
$CCM_Sub = $Central_Check_Minus.Name.Substring($Central_Check_Minus.name.Length - 12)
$SCM_Sub_Trim = $SCM_Sub.Substring(0,8)
$NCM_Sub_Trim = $NCM_Sub.Substring(0,8)
$CCM_Sub_Trim = $CCM_Sub.Substring(0,8)
$SCM_10_Sub = $South_Check_10_Minus.Name.Substring($South_Check_10_Minus.name.Length - 12)
$NCM_10_Sub = $North_Check_10_Minus.Name.Substring($North_Check_10_Minus.name.Length - 12)
$CCM_10_Sub = $Central_Check_10_Minus.Name.Substring($Central_Check_10_Minus.name.Length - 12)
$SCM_Sub_10_Trim = $SCM_10_Sub.Substring(0,8)
$NCM_Sub_10_Trim = $NCM_10_Sub.Substring(0,8)
$CCM_Sub_10_Trim = $CCM_10_Sub.Substring(0,8)

#Measuring if todays date does not equal the previous date from the log. 
if ($Date -ne $SCM_Sub_Trim){

    $South_Minus_Removal = $South_Check_Minus.Name
    $North_Minus_Removal = $North_Check_Minus.Name
    $Central_Minus_Removal = $Central_Check_Minus.Name
    $South_Minus10_Removal = $South_Check_10_Minus.Name
    $North_Minus10_Removal = $North_Check_10_Minus.Name
    $Central_Minus10_Removal = $Central_Check_10_Minus.Name

    $SouthCheck_Name = $South_Check.name #Current Date
    $NorthCheck_Name = $North_Check.Name #Current Date
    $CentralCheck_Name = $Central_Check.Name #Current Date

    $Previous_SAC = Import-Csv -path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$South_Minus_Removal"
    $Previous_NAC = Import-Csv -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$North_Minus_Removal"
    $Previous_CAC = Import-Csv -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$Central_Minus_Removal"
    $Previous_SAC_10 = Import-Csv -path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$South_Minus10_Removal"
    $Previous_NAC_10 = Import-Csv -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$North_Minus10_Removal"
    $Previous_CAC_10 = Import-Csv -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$Central_Minus10_Removal"
    
    $Previous_SAC_Count = $Previous_SAC.Count
    $Previous_NAC_Count = $Previous_NAC.Count
    $Previous_CAC_Count = $Previous_CAC.Count
    $Previous_SAC_10_Count = $Previous_SAC_10.Count
    $Previous_NAC_10_Count = $Previous_NAC_10.Count
    $Previous_CAC_10_Count = $Previous_CAC_10.Count

    $Copy_South = Copy-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$South_Minus_Removal" -Destination "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows_10_Migration_Container" -Force
    $Copy_North = Copy-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$North_Minus_Removal" -Destination "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows_10_Migration_Container" -Force
    $Copy_Central = Copy-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$Central_Minus_Removal" -Destination "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows_10_Migration_Container" -Force
    $Copy_South10 = Copy-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$South_Minus10_Removal" -Destination "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows_10_Migration_Container" -Force
    $Copy_North10 = Copy-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$North_Minus10_Removal" -Destination "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows_10_Migration_Container" -Force
    $Copy_Central10 = Copy-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$Central_Minus10_Removal" -Destination "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows_10_Migration_Container" -Force
    
    $Remove_South = Remove-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$South_Minus_Removal" 
    $Remove_North = Remove-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$North_Minus_Removal" 
    $Remove_Central = Remove-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$Central_Minus_Removal" 
    $Remove_South10 = Remove-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$South_Minus10_Removal" 
    $Remove_North10 = Remove-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$North_Minus10_Removal" 
    $Remove_Central10 = Remove-Item -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\$Central_Minus10_Removal" 

 }

 
$Body = " 
<b> <font size ='14pt'> Windows 10 Migration Stats -  $Date2 </font> </b><br/>
<br/>
<b>Microsoft Windows 10 Enterprise</b>- $Win10Ent_Counted<br/>
<b>Microsoft Windows 10 Enterprise 2016 LTSB</b>: $Win10ELTSB_Counted<br/>
<b>Microsoft Windows 10 Pro</b>: $Win10Pro_Counted<br/>
<b>Microsoft Windows 7 Enterprise</b>: $Win7Ent_Counted<br/>
<b>Microsoft Windows 7 Enterprise N</b>: $Win7EntN_Counted<br/>
<b>Microsoft Windows 7 Professional</b>: $Win7Pro_Counted<br/>
<b>Microsoft Windows 8.1 Pro</b>: $Win8Pro_Counted<br/>
<b>Microsoft Windows Embedded Standard</b>: $WinEmb_Counted<br/>
<br/>
<b>Field Services Central</b><br/>
Central Total Device Count - $CAC <br/>
Central Windows 10 Migration Completed - $CAC_Comp <br/>
<br/>
<b>Field Services South</b> 
<br/>
South Total Device Count - $SAC <br/>/
South Windows 10 Migration Completed - $SAC_Comp <br/>
<br/>
<b>Field Services North</b><br/>
North Total Device Count  - $NAC<br/>
North Windows 10 Migration Completed - $NAC_Comp<br/>
<br/>
<b>These numbers are reflected from Active Directory. If a device is not setup under the Workstations OU, it will not appear here.</b><br/>
<br/>
<b><font size ='14pt'>Previous Numbers</font></b><br/>
<br/>
<b>Field Services Central</b><br/>
Central Total Device Count - $Previous_CAC_Count <br/>
Central Windows 10 Migration Completed - $Previous_CAC_10_Count<br/>
<br/>
<b>Field Services South</b><br/>
South Total Device Count - $Previous_SAC_Count <br/>
South Windows 10 Migration Completed - $Previous_SAC_10_Count<br/>
<br/>
<b>Field Services North</b><br/>
North Total Device Count  - $Previous_NAC_Count  <br/>
North Windows 10 Migration Completed - $Previous_NAC_10_Count<br/>"

Send-MailMessage -To $MailTo -From $MailFrom -Subject $Subject -SMTPServer $MailServer -Body $Body -BodyAsHtml -Attachments '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Windows 10 Migration.xlsx'