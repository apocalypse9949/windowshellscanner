@echo off
setlocal enabledelayedexpansion

:: ==============================
:: Remote Access Security Audit
:: ==============================

set LOGFILE=%~dp0remote_audit_%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%.txt
echo Security Audit - %date% %time% > "%LOGFILE%"
echo ============================================== >> "%LOGFILE%"

:: --- Check TermService (RDP) ---
echo [*] Checking RDP Service Status... >> "%LOGFILE%"
sc query termservice >> "%LOGFILE%" 2>&1

:: --- Check RDP Sessions (if available) ---
echo. >> "%LOGFILE%"
echo [*] Checking Active RDP Sessions... >> "%LOGFILE%"
if exist C:\Windows\System32\qwinsta.exe (
    qwinsta >> "%LOGFILE%" 2>&1
) else (
    echo qwinsta not available. >> "%LOGFILE%"
)
if exist C:\Windows\System32\query.exe (
    query session >> "%LOGFILE%" 2>&1
) else (
    echo query not available. >> "%LOGFILE%"
)

:: --- Remote Assistance Status ---
echo. >> "%LOGFILE%"
echo [*] Checking Remote Assistance Config... >> "%LOGFILE%"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /s >> "%LOGFILE%" 2>&1

:: --- Open Ports (RDP, VNC, RATs) ---
echo. >> "%LOGFILE%"
echo [*] Checking Open Network Ports... >> "%LOGFILE%"
netstat -ano >> "%LOGFILE%" 2>&1

:: --- Running Services ---
echo. >> "%LOGFILE%"
echo [*] Checking Suspicious Services... >> "%LOGFILE%"
sc query type= service state= all >> "%LOGFILE%" 2>&1

:: --- Scheduled Tasks ---
echo. >> "%LOGFILE%"
echo [*] Checking Scheduled Tasks... >> "%LOGFILE%"
schtasks /query /fo LIST /v >> "%LOGFILE%" 2>&1

:: --- Startup Programs ---
echo. >> "%LOGFILE%"
echo [*] Checking Startup Programs... >> "%LOGFILE%"
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run >> "%LOGFILE%" 2>&1
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run >> "%LOGFILE%" 2>&1

:: --- Installed Remote Tools (TeamViewer, AnyDesk, etc.) ---
echo. >> "%LOGFILE%"
echo [*] Checking Installed Remote Access Software... >> "%LOGFILE%"
wmic product get name,version | findstr /I "TeamViewer AnyDesk UltraViewer VNC LogMeIn GoToMyPC Splashtop ZohoAssist" >> "%LOGFILE%" 2>&1

:: --- Active Processes ---
echo. >> "%LOGFILE%"
echo [*] Listing Active Processes... >> "%LOGFILE%"
tasklist /v >> "%LOGFILE%" 2>&1

:: --- End ---
echo. >> "%LOGFILE%"
echo Security Audit Completed. Log saved to: %LOGFILE%
echo ============================================== >> "%LOGFILE%"
