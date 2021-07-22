$excel = New-Object -ComObject excel.application
$excel.visible = $true

$outputpath = 'C:\temp\Windows 10 Migration.xlxs'

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

$records = Import-Csv "\\hqsbvnxfile1\global\grlewis\Logs\Win10Migration.csv"

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