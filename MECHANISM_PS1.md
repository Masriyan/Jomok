# 🪟 jomok.ps1: Windows PowerShell Payload Mechanism

`jomok.ps1` (V17.2 GOD MODE) is the Windows equivalent of `jomok.sh`. It leverages native PowerShell capabilities and .NET framework integration to execute advanced disruption, exfiltration, and persistence strategies.

## Core Mechanisms

### 1. In-Depth Anti-Debugging
- Similar to the batch script, it cross-references running processes against an extensive list of debuggers and network analyzers.
- Further utilizes `[System.Diagnostics.Debugger]::IsAttached` to detect managed debuggers attached to the PowerShell process.
- Implements a global Mutex (`Global\JomokMtx_V17`) to prevent multiple instances from colliding and crashing the system prematurely.

### 2. .NET Interoperability
- Uses `Add-Type` to compile C# code on the fly, accessing native Windows APIs (like `user32.dll`) to enforce wallpaper locks programmatically via `SystemParametersInfo`, making it harder for users to revert changes.
- Leverages the `WMPlayer.OCX` COM object to download and loop audio invisibly in the background.

### 3. Aggressive Persistence & Watchdog
- **Scheduled Tasks:** Utilizes `New-ScheduledTaskAction` to create a deeply hidden, recurring task triggering every minute.
- **Registry Manipulation:** Injects hidden startup keys.
- **Anti-Kill Watchdog:** Spawns a detached background job that continuously queries `Get-Process`. If the main payload is terminated by the user or EDR, the watchdog instantaneously launches a new hidden instance.

### 4. System Disruption
- **Unlimited Image Spread:** Recursively traverses common Windows directories (Desktop, Documents, Downloads, etc.) and duplicates a targeted image endlessly with randomized names, severely cluttering the file system.
- **GUI Pop-ups:** Periodically triggers the default image viewer using `Start-Process`, interrupting the user's workflow.

### 5. Resource Starvation
- **CPU Burn:** Calculates the total number of logical processors and spawns an equal number of background jobs executing infinite mathematical loops (e.g., `[Math]::Sqrt()`), pegging the CPU at 100%.
- **RAM Bombing:** Allocates 256MB byte arrays into an expanding `ArrayList` within a continuous loop, leading to system paging, extreme lag, and eventual out-of-memory (OOM) crashes.

### 6. Event Log Flooding & Exfiltration
- **SIEM Distraction:** Writes fake, highly critical event logs (Event ID 1000-9999) directly to the Windows Application Event Log to misdirect Incident Response teams.
- **Data Harvesting:** Background jobs recursively search for SSH keys, `.env` files, credentials, and databases, streaming the raw content back to a simulated C2 server via `Invoke-WebRequest`.
