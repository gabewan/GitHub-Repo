$command = {$Text = @'

'@
Add-Type -AssemblyName System.Windows.Forms
$Label = New-Object System.Windows.Forms.Label
$Label.TabIndex = 1
$Label.Text = $Text
$Label.ForeColor = 'White'
$Label.AutoSize = $True
$Label.Font = "Lucida Console, 30pt, style=Regular"
$Label.Location = '0, 30'
$Form = New-Object system.Windows.Forms.Form
$Form.Controls.Add($Label)
$Form.WindowState = 'Maximized'
$Form.FormBorderStyle = 'None'
$Form.BackColor = "#000080"
$Form.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
$Form.ShowDialog()
}
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)
powershell.exe -encodedCommand $encodedCommand