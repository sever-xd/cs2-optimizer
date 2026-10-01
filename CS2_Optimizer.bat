@echo off
chcp 65001 >nul
color 0B
title CS2 Pro Optimizer - License Activation

:: Admin check
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

cls
echo ================================================================
echo               CS2 PRO OPTIMIZER - ACTIVATION
echo ================================================================
echo.

:: Get Hardware ID
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance -ClassName Win32_ComputerSystemProduct).UUID"`) do set "CLIENT_HWID=%%A"

:: Copy HWID to clipboard
powershell -NoProfile -Command "Set-Clipboard -Value '%CLIENT_HWID%'" >nul 2>&1

echo Your Hardware ID (HWID):
echo ----------------------------------------------------------------
echo   %CLIENT_HWID%
echo ----------------------------------------------------------------
echo [+] HWID copied to clipboard! (Press Ctrl+V in FunPay chat)
echo.

:INPUT_KEY
set "USER_KEY="
set /p USER_KEY="Enter your license key: "
if "%USER_KEY%"=="" goto INPUT_KEY

echo.
echo [*] Verifying license with server...

powershell -NoProfile -Command "$hwid = '%CLIENT_HWID%'.Trim(); $key = '%USER_KEY%'.Trim(); $url = 'https://sever-xd.github.io/cs2-optimizer/licenses.json?t=' + (Get-Date).Ticks; try { $data = Invoke-RestMethod -Uri $url -TimeoutSec 10; if ($data.$hwid -and $data.$hwid -eq $key) { exit 0; } else { exit 1; } } catch { exit 2; }"

set CHECK_STATUS=%errorlevel%

if %CHECK_STATUS% equ 1 (
    echo.
    echo [-] ERROR: Invalid key or key not registered for this PC!
    echo     Send your HWID to the seller on FunPay.
    echo.
    pause
    goto INPUT_KEY
)

if %CHECK_STATUS% equ 2 (
    echo.
    echo [-] ERROR: Could not connect to activation server.
    echo     Check your internet connection.
    echo.
    pause
    exit /b
)

cls
color 0A
echo ================================================================
echo        [OK] LICENSE VERIFIED! STARTING OPTIMIZATION...
echo ================================================================
timeout /t 2 >nul
cls

echo ================================================================
echo               CS2 SYSTEM DEEP OPTIMIZATION
echo ================================================================
echo.

echo [1/8] Creating System Restore Point...
powershell -NoProfile -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'CS2_Pro_Backup' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
echo [+] System Restore Point created successfully!
echo.

echo [2/8] Cleaning Temp files and error reports...
del /s /f /q "%temp%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
del /s /f /q "%ProgramData%\Microsoft\Windows\WER\ReportArchive\*.*" >nul 2>&1
del /s /f /q "%ProgramData%\Microsoft\Windows\WER\ReportQueue\*.*" >nul 2>&1
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
echo [+] Temporary files cleaned!
echo.

echo [3/8] Cleaning DirectX and GPU shader caches...
del /s /f /q "%LocalAppData%\D3DSCache\*.*" >nul 2>&1
del /s /f /q "%LocalAppData%\NVIDIA\DXCache\*.*" >nul 2>&1
del /s /f /q "%LocalAppData%\AMD\DxCache\*.*" >nul 2>&1
echo [+] Shader caches cleaned (stutter reduction)!
echo.

echo [4/8] Activating Ultimate / High Performance power plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [+] Maximum Performance power scheme activated!
echo.

echo [5/8] Disabling GameDVR and enabling Game Mode...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
echo [+] GameDVR disabled, Game Mode active!
echo.

echo [6/8] Disabling mouse acceleration (pure 1:1 input)...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo [+] Mouse acceleration disabled!
echo.

echo [7/8] Resetting network stack and flushing DNS...
ipconfig /flushdns >nul 2>&1
netsh int ip reset >nul 2>&1
netsh winsock reset >nul 2>&1
echo [+] Network optimized!
echo.

echo [8/8] Cleaning crash dumps...
del /s /f /q "C:\Windows\Minidump\*.*" >nul 2>&1
del /s /f /q "%SystemDrive%\*.dmp" >nul 2>&1
echo [+] Memory dumps cleaned!
echo.

echo ================================================================
echo          OPTIMIZATION COMPLETED SUCCESSFULLY!
echo ================================================================
echo.
echo Please restart your computer to apply all changes.
echo.
pause
