if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  Write-Host "Please run again as administrator"
  Start-Sleep -s 5
  exit
}

Function Get-Information {
    Add-Type -AssemblyName Microsoft.VisualBasic
    [hashtable]$return = @{}

    while($true)
    {
        $PCName = [Microsoft.VisualBasic.Interaction]::InputBox("What is the desired computer name")
        $Username = [Microsoft.VisualBasic.Interaction]::InputBox("What is the employee name?")
        $Password = Read-Host -AsSecureString "Please enter a temporary password for the employee user account"

        [string] $Message = 'Are these are the correct details of the new employee ?',"`t","`t","`t","`n","`n",
        'Computer Name:',"`t","`t","`t",'{0}',"`n",
        'Computer User Name:',"`t","`t",'{1}'-f $PCName,$Username

        $Answer = [System.Windows.Forms.MessageBox]::Show($Message,'Details Verification','YesNoCancel','Information')
        Write-Host $Answer
        switch ($Answer)
        {
            'Yes' {
            [pscredential]$cred = New-Object System.Management.Automation.PSCredential ($Username, $Password)
            $return.cred = $cred
            $return.pc_name = $PCName
            $return.department = $Department

            return $return

            }

            'Cancel' {exit}
        }
      }
   }

Function Change-User ($Username, $Password) {
Remove-LocalUser -Name "Temp"
New-LocalUser $Username -Password $Password -FullName $Username
Add-LocalGroupMember -Group "Users" -Member $Username

}

Function End-Script{

        [string] $Message = "`t","`t","`t","`n","`n",
        'Some programs need to be restarted to work properly, do you want to restart your computer now?'

        $Answer = [System.Windows.Forms.MessageBox]::Show($Message,'Message','YesNo','Question')
        Write-Host $Answer
        switch ($Answer)
        {
            'Yes' {Restart-Computer -Force}
            'No' {Break}
        }
}

   $Details = Get-Information
    
   Rename-Computer -NewName $Details.pc_name.ToUpper()
   Change-User $Details.cred.UserName $Details.cred.Password