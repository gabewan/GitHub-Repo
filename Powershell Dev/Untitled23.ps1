
Process 
{
  # helper function to locate a open program using by a given Window name
  Function FindWindow([string]$windowName, [int]$retries = 5, [int]$sleepInterval = 1000) {
    
    [int]$currentTry = 0;
    [bool]$windowFound = $false;
    
    Do {
      $currentTry++;
      
      Start-Sleep -Milliseconds $sleepInterval
      Try {
        [Microsoft.VisualBasic.Interaction]::AppActivate($windowName)
        $windowFound = $true;  
      } Catch {
        Write-Host "   [$currentTry out of $retries] failed to find Window with title '$windowName'" -ForegroundColor Yellow
        $windowFound = $false;
      }
    } While ($currentTry -lt $retries -and $windowFound -eq $false)
    

    return $windowFound;
  }

  # import required assemblies
  Add-Type -AssemblyName Microsoft.VisualBasic
  Add-Type -AssemblyName System.Windows.Forms
 
  # first prompt to enter the password
  if(FindWindow("Windows Security")) {
    Start-Sleep -Milliseconds 500
    [System.Windows.Forms.SendKeys]::SendWait('admin{TAB}')  
    [System.Windows.Forms.SendKeys]::SendWait('1111{ENTER}')  

  }
  
} 