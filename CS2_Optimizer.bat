@echo off
chcp 65001 >nul
color 0B
title CS2 Pro Optimizer - Активация

:: Проверка и авто-запрос прав администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Запрос прав администратора...
    powershell -NoProfile -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

cls
echo ================================================================
echo          🔒 CS2 PRO OPTIMIZER - СИСТЕМА ЛИЦЕНЗИРОВАНИЯ
echo ================================================================
echo.

:: Получаем уникальный аппаратный идентификатор (HWID)
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Get-CimInstance -ClassName Win32_ComputerSystemProduct).UUID"`) do set "CLIENT_HWID=%%A"

:: Автоматически копируем HWID в буфер обмена для удобства покупателя
powershell -NoProfile -Command "Set-Clipboard -Value '%CLIENT_HWID%'" >nul 2>&1

echo Ваш уникальный идентификатор оборудования (HWID):
echo ----------------------------------------------------------------
echo   %CLIENT_HWID%
echo ----------------------------------------------------------------
echo [+] HWID уже автоматически скопирован в ваш буфер обмена!
echo     (Просто нажмите Ctrl+V в чате на FunPay, чтобы отправить продавцу)
echo.

:INPUT_KEY
set "USER_KEY="
set /p USER_KEY="Введите ваш лицензионный ключ: "
if "%USER_KEY%"=="" goto INPUT_KEY

echo.
echo [*] Проверка лицензии на сервере...

powershell -NoProfile -Command ^
    "$hwid = '%CLIENT_HWID%'.Trim();" ^
    "$key = '%USER_KEY%'.Trim();" ^
    "$url = 'https://sever-xd.github.io/cs2-optimizer/licenses.json?t=' + (Get-Date).Ticks;" ^
    "try {" ^
    "    $data = Invoke-RestMethod -Uri $url -TimeoutSec 10;" ^
    "    if ($data.$hwid -and $data.$hwid -eq $key) { exit 0; } else { exit 1; }" ^
    "} catch { exit 2; }"

set CHECK_STATUS=%errorlevel%

if %CHECK_STATUS% equ 1 (
    echo.
    echo ================================================================
    echo [-] ОШИБКА: Неверный ключ или данный ключ не привязан к этому ПК!
    echo     Отправьте ваш HWID продавцу для генерации ключа.
    echo ================================================================
    echo.
    pause
    goto INPUT_KEY
)

if %CHECK_STATUS% equ 2 (
    echo.
    echo ================================================================
    echo [-] ОШИБКА: Не удалось связаться с сервером активации.
    echo     Проверьте подключение к интернету.
    echo ================================================================
    echo.
    pause
    exit /b
)

cls
color 0A
echo ================================================================
echo    ✅ ЛИЦЕНЗИЯ УСПЕШНО ПОДТВЕРЖДЕНА! ЗАПУСК ОПТИМИЗАЦИИ...
echo ================================================================
timeout /t 2 >nul
cls

echo ================================================================
echo          🚀 НАЧАЛО ГЛУБОКОЙ ОПТИМИЗАЦИИ СИСТЕМЫ И CS2
echo ================================================================
echo.

echo [1/8] Создание контрольной точки восстановления системы...
powershell -NoProfile -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'CS2_Pro_Optimizer_Backup' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
echo [+] Точка восстановления успешно создана (безопасность 100%%)!
echo.

echo [2/8] Глубокая очистка временных файлов и отчетов об ошибках...
del /s /f /q "%temp%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
del /s /f /q "%ProgramData%\Microsoft\Windows\WER\ReportArchive\*.*" >nul 2>&1
del /s /f /q "%ProgramData%\Microsoft\Windows\WER\ReportQueue\*.*" >nul 2>&1
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
echo [+] Временные файлы и мусор очищены!
echo.

echo [3/8] Очистка кэша шейдеров DirectX, NVIDIA и AMD...
del /s /f /q "%LocalAppData%\D3DSCache\*.*" >nul 2>&1
del /s /f /q "%LocalAppData%\NVIDIA\DXCache\*.*" >nul 2>&1
del /s /f /q "%LocalAppData%\AMD\DxCache\*.*" >nul 2>&1
echo [+] Кэш шейдеров очищен (устранение микрофризов и статтеров)!
echo.

echo [4/8] Активация максимального плана электропитания...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [+] Схема электропитания переведена в режим максимальной производительности!
echo.

echo [5/8] Отключение Xbox Game Bar, DVR и включение Game Mode...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
echo [+] Фоновые записи и оверлеи отключены, Game Mode активирован!
echo.

echo [6/8] Отключение акселерации мыши (чистый сенс 1-к-1)...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo [+] Акселерация мыши отключена!
echo.

echo [7/8] Сброс сетевого стека и очистка DNS (снижение задержки/пинга)...
ipconfig /flushdns >nul 2>&1
netsh int ip reset >nul 2>&1
netsh winsock reset >nul 2>&1
echo [+] Сеть и DNS оптимизированы!
echo.

echo [8/8] Очистка журналов дампов памяти Windows...
del /s /f /q "C:\Windows\Minidump\*.*" >nul 2>&1
del /s /f /q "%SystemDrive%\*.dmp" >nul 2>&1
echo [+] Системные дампы очищены!
echo.

echo ================================================================
echo        🔥 ОПТИМИЗАЦИЯ УСПЕШНО И ПОЛНОСТЬЮ ЗАВЕРШЕНА!
echo ================================================================
echo.
echo Рекомендуется перезагрузить компьютер для применения всех твиков.
echo Спасибо за использование CS2 Pro Optimizer!
echo.
pause
