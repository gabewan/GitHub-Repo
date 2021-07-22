function Write-Log {
     [CmdletBinding()]
     param(
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [string]$Message,
 
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('Information','Warning','Error')]
         [string]$Severity = 'Information'
     )
 
     [pscustomobject]@{
         Time = (Get-Date -f g)
         Message = $Message
         Severity = $Severity
     } | Export-Csv -Path "\\hqsbisilon1\filesrv1\ITS\ITS Desktop Support\GRLEWIS\Powershell Logs\Logs.csv" -Force -Append -NoTypeInformation
 }