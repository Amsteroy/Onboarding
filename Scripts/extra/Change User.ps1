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
            $return.department = $Department

            return $return

            }

            'Cancel' {exit}
        }
      }
   }

Function Change-User ($Username, $Password) {
$UserAccount = Get-LocalUser -Name "Temp"
$UserAccount | Set-LocalUser -Name $Username -Password $Password

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
    
   Rename-Computer -NewName $Details.pc_name
   Change-User -Name $Details.cred.UserName -Password $Details.cred.Password