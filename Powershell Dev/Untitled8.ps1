$ImportFile = Import-Csv '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\GitKraken\Application-Repository\Application-Repository\Grlewis Scripts\Reports\facilities.csv'
$NameFormatRegex = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'
#$REG_EX_Filter_Old = '^([a-zA-Z0-9]{6})([1-2]{1})$' 
$CompObjects = New-Object System.Collections.ArrayList
#$AllComputers = Import-CSV 'C:\temp\ThinClients.csv'
$AllComputers  = Import-Csv 'C:\temp\printer.csv'

foreach ($object in $AllComputers.name) {
    $ComputerName = $object
    $TempObject = "" | Select-Object 'ComputerName', 'BuildingCode', 'DepartmentCode', 'Facility'
    if($ComputerName -match $NameFormatRegex){
        $TempObject.Facility = ( $ImportFile | Where-Object {$_.buildingcode -eq $matches.1 -and $_.department -eq $matches.2}).facility
        $TempObject.ComputerName = $ComputerName
        $TempObject.BuildingCode = $Matches.1
        $TempObject.DepartmentCode = $Matches.2
        if($TempObject.Facility -eq $null){
            $TempObject.Facility = "Unknown combo - " + $TempObject.BuildingCode + $TempObject.DepartmentCode
        }
    $CompObjects.Add($TempObject) | Out-Null
    } else {
        continue
    }
}

$CompObjects | Export-Csv 'C:\temp\Printarray.csv'
$Msg_Count = Import-Csv 'C:\temp\Printarray.csv'
#$Msg_Count = Import-Csv '\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\ScriptLogs\Win10Migration_RAW.csv' 
#$MailTo = 'gabe.lewis@nghs.com'#$FS_Emails
#$MailFrom = "Windows 10 Migration<gabe.lewis@nghs.com>"
#$MailServer = "mail.nghs.com"
#$Subject = "Inventory - Windows 10"

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
   $Comp_Regex = $Computer.Substring(0,6)

    if ($North_Members -contains $Comp_Regex){
         
         $NorthObjects = "" | Select-Object 'ComputerName'
         $NorthObjects.ComputerName = $Computer
         $North_Array.Add($NorthObjects)      
                   
    }
    if ($Central_Members -contains $Comp_Regex){
         
         $CentralObjects = "" | Select-Object 'ComputerName'
         $CentralObjects.ComputerName = $Computer
         $Central_Array.Add($CentralObjects)
            
   
    }
    if ($South_Members -contains $Comp_Regex){
        
        $SouthObjects = "" | Select-Object 'ComputerName'
         $SouthObjects.ComputerName = $Computer
         $South_Array.Add($SouthObjects) 
    }
 }

 $North_Array | Export-Csv c:\temp\northprinters.csv -Force -NoTypeInformation
  $South_Array | Export-Csv c:\temp\southprinters.csv -Force -NoTypeInformation
   $Central_Array | Export-Csv c:\temp\centralprinters.csv -Force -NoTypeInformation