@echo off
setlocal enabledelayedexpansion

:: Timestamp for log
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
    set day=%%a
    set month=%%b
    set date=%%c
    set year=%%d
)
set log=wifi_audit_%year%_%month%_%date%.txt

echo ================================================== > %log%
echo Wi-Fi Remote Access Security Audit - %date% %time% >> %log%
echo ================================================== >> %log%

:: Current Wi-Fi connection
echo. >> %log%
echo ---- CURRENT WIFI STATUS ---- >> %log%
netsh wlan show interfaces >> %log%

:: List all stored Wi-Fi profiles
echo. >> %log%
echo ---- SAVED WIFI PROFILES ---- >> %log%
netsh wlan show profiles >> %log%

:: Extract keys for all profiles
for /f "skip=9 tokens=4,*" %%i in ('netsh wlan show profiles') do (
    echo. >> %log%
    echo [WIFI PROFILE] %%i %%j >> %log%
    netsh wlan show profile name="%%i %%j" key=clear >> %log%
)

:: Check for hostednetwork (Rogue AP)
echo. >> %log%
echo ---- HOSTED NETWORK STATUS ---- >> %log%
netsh wlan show hostednetwork >> %log%

:: Check Wi-Fi Direct (Miracast/peer-to-peer risks)
echo. >> %log%
echo ---- WIFI DIRECT DEVICES ---- >> %log%
netsh wlan show drivers | findstr /i "Wi-Fi Direct" >> %log%
netsh wlan show settings >> %log%

:: Firewall rules allowing inbound connections on Wi-Fi
echo. >> %log%
echo ---- FIREWALL RULES ---- >> %log%
netsh advfirewall firewall show rule name=all | findstr /i "wifi wlan wireless" >> %log%

:: Check if ICS (Internet Connection Sharing) is enabled
echo. >> %log%
echo ---- INTERNET CONNECTION SHARING ---- >> %log%
netsh wlan show hostednetwork setting=security >> %log%

:: List open ports (focus on Wi-Fi interfaces)
echo. >> %log%
echo ---- OPEN PORTS ---- >> %log%
netstat -ano >> %log%

:: Running remote-related services
echo. >> %log%
echo ---- REMOTE SERVICES ---- >> %log%
sc query remoteaccess >> %log%
sc query remoteregistry >> %log%
sc query termservice >> %log%
sc query teamviewer >> %log% 2>nul
sc query AnyDesk >> %log% 2>nul

:: Done
echo. >> %log%
echo ================================================== >> %log%
echo Audit completed. Results saved in %log%
echo ==================================================
pause
