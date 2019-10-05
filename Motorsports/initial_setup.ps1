# Creates local admin account
function Create-NewLocalAdmin {
    [CmdletBinding()]
    param([string] $NewLocalAdmin, [securestring] $Password)
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Henry Son (EE'22)"
        Write-Verbose "$NewLocalAdmin local user crated"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
        Set-LocalUser -Name "$NewLocalAdmin" -PasswordNeverExpires $True
        Write-Verbose "$NewLocalAdmin password never expires"
    }
}

function Verify-Password {
    [CmdletBinding()]
    param([string] $username)
    begin {
        $pwd1 = Read-Host -AsSecureString "Create a password for $username"
        $pwd2 = Read-Host -AsSecureString "Re-enter Password" 
        $pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd1))
        $pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))
    }
    process {
        if ($pwd1_text -ceq $pwd2_text) {
            Write-Verbose "Passwords matched"
            Create-NewLocalAdmin -NewLocalAdmin $username -Password $pwd1 -Verbose
        } else {
            Write-Host "Passwords differ"
            Verify-Password -NewLocalAdmin $username
        }
    }
}

$fsaeadmin = "fsaeadmin"
Verify-Password -username $fsaeadmin

$hson = "hson"
Verify-Password -username $hson

# Run pre-installed scripts from Keith
C:msoffice2016activate.bat
Write-Verbose "Microsoft Office activated"

# Restart Computer
Restart-Computer