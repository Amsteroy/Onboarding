if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  Write-Host "Please run again as administrator"
  Start-Sleep -s 5
  exit
}



Function Change-ScreenTimeout
{# For Changing the screen timeout to 15 minutes

powercfg -change -monitor-timeout-ac 15
powercfg -change -monitor-timeout-dc 15
powercfg -change -standby-timeout-ac 15
powercfg -change -standby-timeout-dc 15}

Function New-User ($Username, $Password) {
New-LocalUser $Username -Password $Password -FullName $Username
Add-LocalGroupMember -Group "Administrators" -Member $Username
}

Function End-Script{

        [string] $Message = 'OnBoarding Is Complete!',"`t","`t","`t","`n","`n",
        'Some programs need to be restarted to work properly, do you want to restart your computer now?'

        $Answer = [System.Windows.Forms.MessageBox]::Show($Message,'Message','YesNo','Question')
        Write-Host $Answer
        switch ($Answer)
        {
            'Yes' {Restart-Computer -Force}
            'No' {Break}
        }
}

Function Get-Information {
    Add-Type -AssemblyName Microsoft.VisualBasic
    [hashtable]$return = @{}

    while($true)
    {
        $Username = [Microsoft.VisualBasic.Interaction]::InputBox("What is the employee name?")
        $Department = [Microsoft.VisualBasic.Interaction]::InputBox("Which department will the employee work in?")
        $Password = Read-Host -AsSecureString "Please enter a temporary password for the employee user account"

        [string] $Message = 'Are these are the correct details of the new employee ?',"`t","`t","`t","`n","`n",
        'Computer User Name:',"`t","`t",'{0}',"`n",
        'Employees Department:',"`t","`t",'{1}'-f $Username,$Department

        $Answer = [System.Windows.Forms.MessageBox]::Show($Message,'Details Verification','YesNoCancel','Information')
        Write-Host $Answer
        switch ($Answer)
        {
            'Yes' {
            [pscredential]$cred = New-Object System.Management.Automation.PSCredential ($Username, $Password)
            $return.cred = $cred
            $return.department = $Department

            return $return

            }

            'Cancel' {exit}
        }
      }
   }

Function Download-Chrome{
    $LocalTempDir = $env:TEMP; 
    $ChromeInstaller = "ChromeInstaller.exe"; 
    (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); 
    & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor = "ChromeInstaller"; 
    Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; 
    If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
}


# All the user input needed
$Details = Get-Information 


Change-ScreenTimeout

# Creating a new user and making him admin
New-User $Details.cred.UserName $Details.cred.Password

# Download Google Chrome
Download-Chrome

# Run Download & Install Python Script (It Receives 1 Argument -The Department)

$path_to_download_script = "D:\Onboarding\Onboard-real" 
cd $path_to_download_script
Start-Process $path_to_download_script\main.exe $Details.department -Credential $Details.cred

End-Script