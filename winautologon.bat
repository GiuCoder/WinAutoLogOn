@echo off
set /p USERNAME=Enter your Windows username:
set /p PASSWORD=Enter your Windows password:

REM Check if the username and password are correct
net user "%USERNAME%" "%PASSWORD%" >nul 2>&1
if %errorLevel% == 0 (
    echo Login successful!
) else (
    echo Incorrect username or password. Please try again.
    pause >nul
    exit /b
)

REM Check if the script is running with administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :skip
) else (
    echo Administrator permissions required. Restarting script...
    pause >nul
    cd /d "%~dp0"
    powershell Start-Process cmd.exe -ArgumentList '/c %~dpnx0' -Verb runAs
    exit /b
)

:skip

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "%USERNAME%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "%PASSWORD%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_DWORD /d 1 /f
shutdown -r -t 00
