# Turn on Windows Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Write-Host "Windows Firewall"

# Tracks the MAC address and IP address
$current_location = Get-Location
$notepad_location = "$current_location\$env:COMPUTERNAME.txt"

$IPAddress = ([System.Net.Dns]::GetHostByName($Inputmachine).AddressList[0]).IpAddressToString
$IPMAC = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Inputmachine 
$MACAddress = ($IPMAC | where { $_.IpAddress -eq $IPAddress}).MACAddress 

$file_input = "$IPAddress`n$MACAddress"

New-Item $notepad_location
Set-Content $notepad_location "$file_input"
Write-Host "MAC/IP Addresses"

# Changes the current 'fsaeadmin' user password
function Verify-Password {
    [CmdletBinding()]
    param()
    begin {
        $UserAccount = Get-LocalUser -Name "fsaeadmin"
        $pwd1 = Read-Host -AsSecureString "Change password for $username"
        $pwd2 = Read-Host -AsSecureString "Re-enter Password" 
        $pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd1))
        $pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))
    }
    process {
        if ($pwd1_text -ceq $pwd2_text) {
            Write-Verbose "Passwords matched"
            $UserAccount | Set-LocalUser -Password $Password
        } else {
            Write-Host "Passwords differ"
            Verify-Password
        }
    }
}

Verify-Password 
Write-Host "Change Password"

# Enable Remote Desktop (RDP)
Invoke-Command –Computername “server1”, “Server2” –ScriptBlock {Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" –Value 0}
Invoke-Command –Computername “server1”, “Server2” –ScriptBlock {Enable-NetFirewallRule -DisplayGroup "Remote Desktop"}
Write-Host "Remote Desktop"

# Changes the RDP port number
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$KeyName ="PortNumber"
$NewPort = "3000"

try {
    Set-ItemProperty -Path $RegistryPath -Name $KeyName -Value $NewPort -Force | Out-Null
    Write-Host "RDP Port has been changed."
}
catch {
    Write-Host "Error. Unable to change port number" -ForegroundColor Red
}

# Restarts Computer 
Restart-Computer