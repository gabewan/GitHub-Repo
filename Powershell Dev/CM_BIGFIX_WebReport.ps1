<#     
       .NOTES
       ===========================================================================
       Created with:      SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.170
       Created on:        12/9/2019 12:04 PM
       Created by:        cumenard
       Organization:      NGHS
       Filename:          
       ===========================================================================
       .DESCRIPTION
              A description of the file.
#>

$pass     = Read-Host "Enter LDAP Pass"
$username = "nghs\" + $env:USERNAME
$ie       = New-Object -ComObject internetexplorer.application

$ie.visible = $false
Start-Sleep 1

#open report with user and pass in the url
$ie.Navigate("https://vmwsbigfix01.nghs.com/webreports?Username=$($username)&Password=$($pass)&page=LoggingIn&fwdpage=ExploreComputers#collapseState=&reportInfo=&filterManager=8837225bf9f852f0d8ae81785bc97f3e5f0708fe&chartSection=&wr_computerTable=")