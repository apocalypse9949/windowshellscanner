@echo off
:: ==================================================
:: Windows Remote Access & Wi-Fi Audit Tool
:: Author: Dex
:: ==================================================
setlocal
set OUTPUT=%~dp0Remote_Audit_Report.txt

echo ================================================== >> "%OUTPUT%"
echo   Windows Remote Access & Wi-Fi Security Audit     >> "%OUTPUT%"
echo   Run Date: %date%  Time: %time%                   >> "%OUTPUT%"
echo ================================================== >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Active Network Connections ----
echo [*] Active Network Connections >> "%OUTPUT%"
netstat -ano >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Running Remote Services ----
echo [*] Remote Services Status >> "%OUTPUT%"
sc query termservice >> "%OUTPUT%"
sc query remoteaccess >> "%OUTPUT%"
sc query remoteregistry >> "%OUTPUT%"
sc query winrm >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Installed Remote Drivers / Software ----
echo [*] Installed Remote Display / Remote Control Drivers >> "%OUTPUT%"
driverquery /v /fo list | findstr /i "remote vnc rdp anydesk teamviewer spacedesk" >> "%OUTPUT%"
wmic product get name,version | findstr /i "remote vnc rdp anydesk teamviewer spacedesk" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Running Processes for RATs ----
echo [*] Running Processes (Suspicious Keywords) >> "%OUTPUT%"
tasklist /v | findstr /i "rdp vnc teamviewer anydesk spacedesk chrome remote desktop" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Firewall Rules ----
echo [*] Firewall Rules Allowing Remote Access >> "%OUTPUT%"
netsh advfirewall firewall show rule name=all | findstr /i "rdp remote vnc anydesk teamviewer spacedesk" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Listening Ports ----
echo [*] Listening Ports >> "%OUTPUT%"
netstat -abno >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Wi-Fi Profiles ----
echo [*] Saved Wi-Fi Profiles >> "%OUTPUT%"
netsh wlan show profiles >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Current Wi-Fi Connection ----
echo [*] Current Wi-Fi Connection >> "%OUTPUT%"
netsh wlan show interfaces >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Wi-Fi Policy & Settings ----
echo [*] Wi-Fi Group Policy Settings >> "%OUTPUT%"
netsh wlan show settings >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Remote Desktop Config ----
echo [*] Remote Desktop Configuration >> "%OUTPUT%"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Auto-Start Programs ----
echo [*] Auto-Start Programs >> "%OUTPUT%"
wmic startup get caption,command >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Check Scheduled Tasks ----
echo [*] Scheduled Tasks (Suspicious) >> "%OUTPUT%"
schtasks /query /fo list /v | findstr /i "remote vnc rdp anydesk teamviewer spacedesk" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: ---- Final Note ----
echo ================================================== >> "%OUTPUT%"
echo   Audit Completed. Check "%OUTPUT%" for results.   >> "%OUTPUT%"
echo ================================================== >> "%OUTPUT%"

echo Done! Full audit written to: %OUTPUT%
pause
