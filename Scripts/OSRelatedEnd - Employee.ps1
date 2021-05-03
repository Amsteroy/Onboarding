function Set-DefaultBrowser {
Add-Type -AssemblyName 'System.Windows.Forms'
Start-Process $env:windir\system32\control.exe -LoadUserProfile -Wait -ArgumentList '/name Microsoft.DefaultPrograms /page pageDefaultProgram\pageAdvancedSettings?pszAppName=Firefox-308046B0AF4A39CB'
Sleep 5
[System.Windows.Forms.SendKeys]::SendWait("{TAB}{TAB}{TAB}{TAB}{TAB}{ENTER}")
Sleep 2
[System.Windows.Forms.SendKeys]::SendWait("{TAB}{ENTER}")
Sleep 2
[System.Windows.Forms.SendKeys]::SendWait("{TAB}{ENTER} ")
}

# Sets Default browser - Chrome
Set-DefaultBrowser


