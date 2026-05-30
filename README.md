# Jomok Payload V17.2 - GOD MODE HARDENED

Jomok is the first malware created by using Claude 4.8 and this repo for **authorized research and educational purposes only**. This repository provides various implementations of the payload across multiple platforms, including Bash (`jomok.sh`), PowerShell (`jomok.ps1`), Batch (`jomok.bat`), and Python (`jomok.py`).

## ⚠️ Disclaimer
**This project is for educational and authorized research purposes only.** Do not use these scripts on systems you do not own or have explicit permission to test. The author is not responsible for any misuse or damage caused by this toolkit.

## Features

The primary script, `jomok.sh` (V17.2 GOD MODE HARDENED), demonstrates advanced execution and obfuscation techniques:
- **In-Memory Decryption:** The core payload is encrypted using a 256-bit XOR cipher. It is decrypted in-memory using a Python subprocess, ensuring the plaintext payload never touches the disk.
- **Process Hiding & Evasion:** Execution is designed to leave minimal traces in standard bash histories. It runs in a new session detached from the terminal.
- **Media Interaction:** The payload demonstrates execution capabilities by interacting with external media (e.g., downloading images and playing YouTube audio via command line tools).
- **Shared Memory Usage:** Utilizes volatile storage (`/dev/shm` or `/tmp`) to store temporary artifacts.
- **Cross-Platform Support:** Additional scripts (`jomok.py`, `jomok.bat`, `jomok.ps1`) demonstrate similar concepts across different operating systems.

## Repository Structure

- `jomok.sh`: The advanced bash payload using XOR encryption and Python for in-memory execution.
- `jomok.py`: Python implementation of the payload with built-in Base64 image dropping and subprocess execution.
- `jomok.ps1`: PowerShell implementation for Windows environments.
- `jomok.bat`: Windows Batch implementation.
- `final_wrapper.sh`: A wrapper script for payload deployment.

## Installation & Usage

Clone the repository:
```bash
git clone https://github.com/Masriyan/Jomok.git
cd Jomok
```

### Running `jomok.sh`
To execute the bash payload on Linux/macOS:
```bash
chmod +x jomok.sh
./jomok.sh
```

### Running `jomok.py`
To execute the python payload (requires Python 3):
```bash
python3 jomok.py
```

### Running Windows Payloads
For `jomok.bat` or `jomok.ps1`, run them directly from the Windows command prompt or PowerShell. Ensure you have the appropriate execution policies enabled for PowerShell.

## Contributing
Contributions are welcome. Please open an issue or submit a pull request on the [GitHub repository](https://github.com/Masriyan/Jomok).

## License
For more details, please visit the main repository at [https://github.com/Masriyan/Jomok](https://github.com/Masriyan/Jomok).
