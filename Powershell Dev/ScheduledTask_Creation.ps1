$action = New-ScheduledTaskAction -Execute 'Powershell.exe' `

  -Argument '-ExecutionPolicy Bypass -File "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\SmartGit\Grlewis Scripts\Reports\printers_winprn.csv"'

$trigger =  New-ScheduledTaskTrigger -Daily -At 9am

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AppLog" -Description "Daily dump of Applog"