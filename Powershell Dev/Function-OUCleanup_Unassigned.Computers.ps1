#region ModuleImport and Requires
#requires -Module ActiveDirectory
#endregion

<#
.SYNOPSIS
    Remove all Full Client Computers and Laptops from OU=Computers and OU=Unassigned. This script will move all devices that are online and registered as a Desktop or Laptop.
.DESCRIPTION
     This function will only allow for the removal of Desktops and Laptops from the Computers OU and Unassigned OU. Exports all information before and after the migration to a logs folder. 
     RegEx filters all data to only grab the characters listed in the function. This will include the old barcodes for dell devices and the new epic name. 
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    General notes
#>

function Start-NGHSADCleanup {
  [CmdletBinding()]
  param()    
  begin {
      $Import_Computers_OU = Get-ADComputer -Filter * -SearchBase "CN=computers,DC=nghs,DC=com" | Select-Object name | Sort-Object name  
      $Import_Unassigned_OU = Get-ADComputer -Filter * -SearchBase "OU=unassigned,OU=workstations,DC=nghs,DC=com" | Select-Object name | Sort-Object name 

      $REG_EX_Filter_Old = '^([0-9a-zA-Z]{6})([1-2]{1}$)' 
      $REG_EX_Filter = '(^\d{3})(\w{3})([a-zA-Z]{2})(\d{3})'

      $TargetOULap = "OU=laptops,OU=workstations,DC=nghs,DC=com"
      $TargetOUDep = "OU=desktops,OU=workstations,DC=nghs,DC=com"

      $Export_Objects_CompOU_Array = New-Object System.Collections.ArrayList
      $Export_Objects_UnasOU_Array = New-Object System.Collections.ArrayList

      $Import_Computers_OU | Out-File '\\hqsbvnxfile1\global\grlewis\logs\Export_Computers_OU.csv' -Force 
      $Import_Unassigned_OU | Out-File '\\hqsbvnxfile1\global\grlewis\logs\Export_Unassigned_OU.csv' -Force 
  }
  
  process {
      foreach ($Computer in $Import_Computers_OU) {
          $Array_ComputersOU = "" | Select-Object 'Device', 'CurrentLocation', 'NewLocation', 'Date', 'Online', 'DeviceType' #Create a storage array 
          if ($computer.name -match $REG_EX_Filter) {
              #Matches the barcode ID and gets any device with matching identifiers. 
              $Device = $Computer.Name #Change the string name over for Reporting
              if (Test-Connection -ComputerName $Computer.name -Count 1 -ErrorAction SilentlyContinue) {
                  #Make sure the device is online so we can monitor Tombstone activity.
                  $Array_ComputersOU.Online = "Online"
                  $Device_Properties = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Device -ErrorAction SilentlyContinue  #Find the Device Types. Laptop or Desktop (If the device is active)
                  if($Null -eq $Device_Properties){
                      continue
                  }
                  
                  $Model = $Device_Properties | Select-Object -ExpandProperty PCSystemType
                  if ($Model -eq 1) {
                      #Device is a Desktop and currently Online.
                      Get-ADComputer $Device | Move-ADObject -TargetPath $TargetOUDep -PassThru #Device is going to be placed in the Desktops OU in Active Directory.
                      $Desktop_OU = "OU=desktops,OU=workstations,DC=nghs,DC=com" 
                      $Array_ComputersOU.NewLocation = $Desktop_OU
                      $Array_ComputersOU.DeviceType = $Device_Properties.Model
                  }
      
                  # Would change to elseif
                  if ($Model -eq 2) {
                      #Device is a Laptop and currently Online.
                      Get-ADComputer $Name | Move-ADObject -TargetPath $TargetOULap -PassThru #Device is going to be placed in the Laptops OU in Active Directory.
                      $Laptop_OU = "OU=laptops,OU=workstations,DC=nghs,DC=com" 
                      $Array_ComputersOU.DeviceType = $Device_Properties.Model
                      $Array_ComputersOU.NewLocation = $Laptop_OU
                  }
              } else {
                  $Array_ComputersOU.Online = "Offline"
                  $Array_ComputersOU.NewLocation = "null"
                  $Array_ComputersOU.DeviceType = "Unavailable"
              }
          } #if REG_EX_Filter
          if ($computer.name -match $REG_EX_Filter_Old) {
              #Matches the old barcode ID and gets any device with matching identifiers. 
              $Device = $Computer.Name #Change the string name over for Reporting
              if (Test-Connection -ComputerName $Computer.name -Count 1 -ErrorAction SilentlyContinue) {
                  #Make sure the device is online so we can monitor Tombstone activity.
                  $Array_ComputersOU.Online = "Online"
                  $Device_Properties = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Device -ErrorAction SilentlyContinue  #Find the Device Types. Laptop or Desktop (If the device is active)
                  if($Null -eq $Device_Properties){
                      continue
                  }
                  $Model = $Device_Properties | Select-Object -ExpandProperty PCSystemType
                  if ($Model -eq 1) {
                      #Device is a Desktop and currently Online.
                      Get-ADComputer $Device | Move-ADObject -TargetPath $TargetOUDep -PassThru #Device is going to be placed in the Desktops OU in Active Directory.
                      $Array_ComputersOU.NewLocation = "OU=desktops,OU=workstations,DC=nghs,DC=com" 
                      $Array_ComputersOU.DeviceType = $Device_Properties.Model
                  }
      
                  # Would change to elseif
                  if ($Model -eq 2) {
                      #Device is a Laptop and currently Online.
                      Get-ADComputer $Name | Move-ADObject -TargetPath $TargetOULap -PassThru -WhatIf #Device is going to be placed in the Laptops OU in Active Directory.
                      $Array_ComputersOU.NewLocation = "OU=laptops,OU=workstations,DC=nghs,DC=com" 
                      $Array_ComputersOU.DeviceType = $Device_Properties.Model
                  }
              } else {
                  $Array_ComputersOU.Online = "Offline"
                  $Array_ComputersOU.NewLocation = "null"
                  $Array_ComputersOU.DeviceType = "Unavailable"
              }
          } #if OLD reg_ex_filter
          $Array_ComputersOU.Device = $Computer.name
          $Array_ComputersOU.Date = Get-Date 
          $Array_ComputersOU.CurrentLocation = "CN=computers,DC=nghs,DC=com"
          $Export_Objects_CompOU_Array.Add($Array_ComputersOU) | Out-Null
      }
      Foreach ($Computer in $Import_Unassigned_OU) {
          $Array_UnassignedOU = "" | Select-Object 'Device', 'CurrentLocation', 'NewLocation', 'Date', 'Online', 'DeviceType'
          if ($computer.name -match $REG_EX_Filter) {
              #Matches the barcode ID and gets any device with matching identifiers. 
              $Device = $Computer.Name #Change the string name over for Reporting
              if (Test-Connection -ComputerName $Computer.name -Count 1 -ErrorAction SilentlyContinue) {
                  #Make sure the device is online so we can monitor Tombstone activity.
                  $Array_UnassignedOU.Online = "Online"
                  $Device_Properties = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Device -ErrorAction SilentlyContinue  #Find the Device Types. Laptop or Desktop (If the device is active)
                  if($Null -eq $Device_Properties){
                      continue
                  }
                  $Model = $Device_Properties | Select-Object -ExpandProperty PCSystemType
                  if ($Model -eq 1) {
                      #Device is a Desktop and currently Online.
                      Get-ADComputer $Device | Move-ADObject -TargetPath $TargetOUDep -PassThru  #Device is going to be placed in the Desktops OU in Active Directory.
                      $Desktop_OU = "OU=desktops,OU=workstations,DC=nghs,DC=com" 
                      $Array_UnassignedOU.NewLocation = $Desktop_OU
                      $Array_UnassignedOU.DeviceType = $Device_Properties.Model
                  }
                  # Would change to elseif
                  if ($Model -eq 2) {
                      #Device is a Laptop and currently Online.
                      Get-ADComputer $Name | Move-ADObject -TargetPath $TargetOULap -PassThru  #Device is going to be placed in the Laptops OU in Active Directory.
                      $Laptop_OU = "OU=laptops,OU=workstations,DC=nghs,DC=com" 
                      $Array_UnassignedOU.DeviceType = $Device_Properties.Model
                      $Array_UnassignedOU.NewLocation = $Laptop_OU
                  }
              } else {
                  $Array_UnassignedOU.Online = "Offline"
                  $Array_UnassignedOU.NewLocation = "null"
                  $Array_UnassignedOU.DeviceType = "Unavailable"
              }
          }
          if ($computer.name -match $REG_EX_Filter_Old) {
              #Matches the old barcode ID and gets any device with matching identifiers. 
              $Device = $Computer.Name #Change the string name over for Reporting
              if (Test-Connection -ComputerName $Computer.name -Count 1 -ErrorAction SilentlyContinue) {
                  #Make sure the device is online so we can monitor Tombstone activity.
                  $Array_UnassignedOU.Online = "Online"
                  $Device_Properties = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Device -ErrorAction SilentlyContinue  #Find the Device Types. Laptop or Desktop (If the device is active)
                  if($Null -eq $Device_Properties){
                      continue
                  }
                  $Model = $Device_Properties | Select-Object -ExpandProperty PCSystemType
                  if ($Model -eq 1) {
                      #Device is a Desktop and currently Online.
                      Get-ADComputer $Device | Move-ADObject -TargetPath $TargetOUDep -PassThru  #Device is going to be placed in the Desktops OU in Active Directory.
                      $Array_UnassignedOU.NewLocation = "OU=desktops,OU=workstations,DC=nghs,DC=com" 
                      $Array_UnassignedOU.DeviceType = $Device_Properties.Model
                  }
                  # Would change to elseif
                  if ($Model -eq 2) {
                      #Device is a Laptop and currently Online.
                      Get-ADComputer $Name | Move-ADObject -TargetPath $TargetOULap -PassThru  #Device is going to be placed in the Laptops OU in Active Directory.
                      $Array_UnassignedOU.NewLocation = "OU=laptops,OU=workstations,DC=nghs,DC=com" 
                      $Array_UnassignedOU.DeviceType = $Device_Properties.Model
                  }
              } else {
                  $Array_UnassignedOU.Online = "Offline"
                  $Array_UnassignedOU.NewLocation = "null"
                  $Array_UnassignedOU.DeviceType = "Unavailable"
              }
          }
          $Array_UnassignedOU.Device = $Computer.name
          $Array_UnassignedOU.Date = Get-Date 
          $Array_UnassignedOU.CurrentLocation = "CN=computers,DC=nghs,DC=com"
          $Export_Objects_UnasOU_Array.Add($Array_UnassignedOU) | Out-Null
      }
  }
  
  end {

      $Export_Objects_CompOU_Array | Export-Csv -Path '\\hqsbvnxfile1\global\grlewis\logs\Updated_Export_ComputersOU.csv' -NoTypeInformation -Force
      $Export_Objects_UnasOU_Array | Export-Csv -Path '\\hqsbvnxfile1\global\grlewis\logs\Updated_Export_UnassignedOU.csv' -NoTypeInformation -Force
  }
}

