     $SECDB = 'http://vmdbaccesscont2/CESIReportExecAdmin/AppMain.aspx'
     $ie = New-Object -ComObject InternetExplorer.Application
     $ie.visible = $true
     $ie.Navigate("$SECDB")
     Start-Sleep 5
     $user = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like "txtusername"}
     $Pass = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.type -eq "Password"}
     $login = $ie.document.IHTMLDocument3_getElementsByTagName('input') | Where-Object {$_.type -eq 'submit'}
     $Paul_User = 'padeleon'
     $Paul_Password = 'Jaynana84'
     $user.value = $Paul_User
     Start-Sleep 1
     $Pass.value = $Paul_Password
     Start-Sleep 1
     $login.click()
     Start-Sleep 1
     $NUC = "http://vmdbaccesscont2/CESIReportExecAdmin/EditUserWizard.aspx?SID=-1"
           'http://vmdbaccesscont2/CESIReportExecAdmin/EditUserWizard.aspx?SID=-1'
     $ie.Navigate("$NUC") #New User Creation

     #Start on User Creation Input
     Start-Sleep 2
     $NUC_Username = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbUserName$textbox1'}

     $NUC_FirstName = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbFirstName$textbox1'}

     $Nuc_Password = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbPassword$textbox1'}

     $NUC_MiddleName = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbMiddleName$textbox1'}

     $NUC_ConfirmPassword = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbConfirmPassword$textbox1'}

     $NUC_LastName = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbLastName$textbox1'}

     $NUC_ReportName = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbCitationName$textbox1'}

     $NUC_EmployeeID = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbEmployeeID$textbox1'}

     $NUC_Rank = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbRank$textbox1'}

     $NUC_HomePhoneNumber = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbHomePhone$textbox1'}

     $NUC_CellPhoneNumber = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbCellPhoneNumber$textbox1'}

     $NUC_EmailAddress = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbEmailAddress$textbox1'}

     $NUC_EmergencyContactName = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbEmergencyContactName$textbox1'}

     $NUC_EmergencyContactPhone = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$tbEmergencyNumber$textbox1'}
     
     $NUC_Admin = $ie.document.IHTMLDocument3_getElementsByTagName('input') | where {$_.name -like 'ctl00$ContentPlaceHolder1$cbHasAdminAccess'}

     $NUC_Username.Value = 'testuser1'
     $NUC_FirstName.value = 'test'
     $Nuc_Password.value = 'TestUser!!123'
     $NUC_MiddleName.value = 'Testerson'
     $NUC_ConfirmPassword.value = $Nuc_Password.value
     $NUC_LastName.value = 'tests'
     $NUC_ReportName.value = 'test'
     $NUC_EmployeeID.value = '99999'
     $NUC_Rank.value = ''
     $NUC_HomePhoneNumber.value = '7702192240'
     $NUC_CellPhoneNumber.value = '7702192240'