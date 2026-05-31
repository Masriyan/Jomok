# 🪟 jomok.bat: Windows Batch Payload Mechanism

`jomok.bat` serves as an advanced dropper and persistence installer for Windows environments. It bridges the gap between basic command-line execution and the full-featured PowerShell payload.

## Core Mechanisms

### 1. Anti-Analysis & Debugging
- Actively scans running processes using `tasklist` for common reverse-engineering tools, including `ollydbg`, `x64dbg`, `ida`, `procmon`, `procexp`, and `wireshark`. If any are found, the batch script terminates immediately.

### 2. Payload Dropping & Extraction
- **Embedded PowerShell:** To minimize dependencies and avoid file drops before execution, the script dynamically writes a highly obfuscated PowerShell script (`jomok.ps1`) to the `%TEMP%` directory.
- Executes the dropped script in a hidden window (`-WindowStyle Hidden`) with `ExecutionPolicy Bypass` to ensure execution regardless of system policies.

### 3. Persistence Installation
The batch script establishes persistence through multiple vectors before handing off execution:
- **Startup Folder:** Copies itself into the user's Startup directory (`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\win_sys_launcher.bat`).
- **Registry Run Keys:** Adds a `SystemRuntimeLauncher` entry to `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`.
- **Scheduled Tasks:** Uses `schtasks` to create a `WindowsSystemMaintenance` task that executes every minute, ensuring the payload is continually re-triggered.

### 4. Immediate Visual Impact
- Downloads a specific payload image to the `%TEMP%` directory.
- Interacts directly with the Windows Registry (`HKCU\Control Panel\Desktop`) to forcefully alter the desktop wallpaper.
- Calls `RUNDLL32.EXE user32.dll,UpdatePerunalizedSettings` to refresh the desktop immediately without requiring a system reboot or user logoff.
