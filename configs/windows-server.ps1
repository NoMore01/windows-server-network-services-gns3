# Windows Server 2022 - commands used in this lab (run in an elevated PowerShell)

# --- NAT: default route out of the external adapter (interface index 3 in this lab)
route add 0.0.0.0 mask 0.0.0.0 25.0.0.2 metric 1 if 3

# --- NTP: sync from time.windows.com and act as a reliable time source
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:YES /update
Restart-Service w32time
w32tm /resync
w32tm /query /status
w32tm /query /peers
New-NetFirewallRule -DisplayName "NTP In" -Direction Inbound -Protocol UDP -LocalPort 123 -Action Allow

# --- FTP: allow control channel
New-NetFirewallRule -DisplayName "FTP In" -Direction Inbound -Protocol TCP -LocalPort 21 -Action Allow

# --- OpenSSH server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-Service -Name sshd
New-NetFirewallRule -DisplayName "SSH In" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow
