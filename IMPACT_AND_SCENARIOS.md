# 🌍 Impact & Real-World Scenarios

The Jomok V17.2 toolkit demonstrates a wide array of tactics commonly seen in Advanced Persistent Threats (APTs), ransomware precursors, and state-sponsored disruption campaigns. Understanding its impact is critical for defensive security teams.

## 💥 System & Organizational Impact

1. **Denial of Service (DoS):**
   - The combined effect of `cpuburn` and `rambomb` mechanisms effectively renders a workstation unusable. Critical business applications will crash, and the operating system will become unresponsive, leading to immediate productivity loss.
2. **Data Compromise:**
   - The automated discovery and exfiltration modules specifically target developers and system administrators (e.g., `id_rsa`, `.env`, `credentials.json`). In a real-world scenario, this leads to lateral movement and total infrastructure compromise.
3. **Incident Response Paralysis:**
   - The SIEM log spilling capabilities (flooding syslog/Windows Event Logs with fake critical alerts) are designed to exhaust the resources of a Security Operations Center (SOC). Analysts will be busy triaging fake brute-force and rootkit alerts while the actual exfiltration occurs.
4. **Psychological Impact:**
   - The unchangeable wallpapers, infinite image flooding, audio looping, and terminal glitches serve as psychological pressure tactics, often utilized by hacktivists or during the disruption phase of ransomware attacks.

---

## 🕵️‍♂️ Real-World Attack Scenarios

### Scenario 1: The Disgruntled Insider (Sabotage)
An employee with standard user privileges executes `jomok.sh` on their corporate Linux workstation before leaving the company. 
- **Result:** Due to the user-level persistence mechanisms (cron, `.bashrc`, systemd-user), the payload survives reboots without requiring root access. The workstation becomes completely bogged down by resource exhaustion, and all local SSH keys are exfiltrated, potentially compromising internal Git repositories or production servers.

### Scenario 2: Phishing & Dropper (Initial Access)
A user is tricked into downloading a seemingly innocuous zip file containing `jomok.bat` disguised as a software update.
- **Result:** The user clicks the batch file. It quickly evades basic antivirus by keeping the main logic obfuscated and dynamically generating the `jomok.ps1` payload. The user's desktop is taken over, and a backdoor is established via Scheduled Tasks. Simultaneously, the Event Log flood triggers massive alerts on the company's SIEM, masking the exfiltration of the user's password manager database (`*.kdbx`).

### Scenario 3: Supply Chain Compromise
The `jomok` logic is subtly injected into a popular open-source NPM or PyPI package as a post-install script.
- **Result:** When developers install the compromised package, the payload silently migrates to `/dev/shm` (on Linux) or memory (on Windows). The anti-debugging checks ensure it doesn't run in automated sandboxes. Once active on the developers' machines, it harvests `.env` files containing AWS keys and database credentials, executing a silent supply chain breach before triggering the chaotic disruption payloads to wipe forensic evidence.
