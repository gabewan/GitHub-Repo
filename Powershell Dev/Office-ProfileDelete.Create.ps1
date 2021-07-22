reg.exe delete "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Outlook\Profiles\" /f
reg.exe delete "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\Profiles\" /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Outlook\Profiles\Outlook" /f
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\Profiles\Outlook" /f