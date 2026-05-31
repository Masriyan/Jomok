# 🐧 jomok.sh: Linux Bash Payload Mechanism

`jomok.sh` (V17.2 GOD MODE HARDENED) is a highly sophisticated, obfuscated bash script designed to demonstrate extreme persistence, evasion, and system disruption on Linux environments.

## Core Mechanisms

### 1. Evasion & Anti-Debugging
- **Signal Hardening:** Traps multiple kill signals (`SIGINT`, `SIGTERM`, `SIGHUP`, etc.) to prevent easy termination.
- **Analysis Tool Detection:** Actively scans for tools like `strace`, `gdb`, `valgrind`, and `sysdig`. If detected, the payload safely aborts.
- **TracerPid Check:** Inspects `/proc/self/status` to determine if the process is being actively debugged.

### 2. Silent Migration & In-Memory Execution
- Copies itself into the volatile shared memory directory (`/dev/shm`), renaming and hiding itself from standard filesystem audits.
- Core logic is XOR-encrypted (256-bit) and decrypted entirely in-memory using an embedded Python subprocess, bypassing static disk signatures.

### 3. Triple Persistence
- **Systemd User Service:** Creates a hidden `.config/systemd/user/sys-runtime.service` and enables it.
- **Cron Jobs:** Injects a recurring cron job for persistent background execution.
- **RC/Profile Injection:** Modifies `.bashrc` and `.profile` to ensure the payload is triggered upon user login.

### 4. Psychological & Visual Disruption
- **Self-Healing Wallpaper Lock:** Forces the desktop environment (GNOME, KDE, XFCE, Mate, Cinnamon) to set a specific image as the background, constantly overriding user changes.
- **Unlimited Image Flood:** Recursively drops images into common user directories (Desktop, Documents, Pictures) with randomized names.
- **Audio Harassment:** Automatically downloads and loops specific audio from YouTube via `yt-dlp` or `youtube-dl`. If unavailable, it falls back to generating system beeps using Python, `aplay`, or `paplay`.
- **Terminal Glitches & Subliminal Messages:** Randomly corrupts the terminal output with colored ASCII/Unicode streams, flashes subliminal text, and triggers fake kernel panic screens.

### 5. Resource Exhaustion (Denial of Service)
- **CPU Core Saturation (`cpuburn`):** Spawns infinite loops tailored to the exact number of CPU cores available, severely degrading system performance.
- **RAM Bombing:** Continuously allocates massive chunks of random data into `/dev/shm` to exhaust available system memory.

### 6. Data Exfiltration & Log Spilling
- **Automated Discovery:** Periodically searches the filesystem up to depth 4 for sensitive files (`id_rsa`, `.env`, `credentials.json`, `*.db`).
- **C2 Simulation:** Silently exfiltrates discovered files via HTTP POST requests to a specified endpoint.
- **SIEM Distraction:** Floods system logs (`/var/log/syslog`, `auth.log`) using the `logger` utility with fake critical alerts (e.g., brute force attempts, unauthorized daemon spawns) to overwhelm SOC analysts.

## Active Watchdog
A dedicated background process continuously monitors the main payload. If the primary process is killed, the watchdog instantaneously respawns it from `/dev/shm`.
