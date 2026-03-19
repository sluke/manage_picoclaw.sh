# Picoclaw Management Script

**Version:** 1.0

This is a terminal-based management script for [Picoclaw](https://github.com/sipeed/picoclaw) that allows you to easily manage Picoclaw processes, systemd service, logs, and configuration interface. It is designed to work in headless environments such as SSH sessions or embedded devices.

---

## Features

- Manage Picoclaw gateway as a **systemd service**  
- Check if Picoclaw is running  
- Start / Stop / Restart service  
- Display service status and Picoclaw command status  
- Launch the **configuration interface** (`picoclaw-launcher-tui`)  
- View logs with **highlighted output** and filtering by **ALL / ERROR / WARN / INFO**  
- Interactive terminal menu and command-line arguments support  
- Version 1.0 included  

---

## Prerequisites

- Linux or macOS with Bash  
- Picoclaw executable and `picoclaw-launcher-tui` in the same directory  
- systemd (for service management)  
- Sufficient permissions to create systemd services (`sudo`)  

---

## Installation

1. Place the script and Picoclaw files in the same directory:

```text
~/download/picoclaw/
├─ picoclaw
├─ picoclaw-launcher-tui
├─ manage_picoclaw.sh
````

2. Make the script executable:

```bash
chmod +x ~/download/picoclaw/manage_picoclaw.sh
```

3. (Optional) Create the logs directory if not already present:

```bash
mkdir -p ~/.picoclaw/logs
```

---

## Usage

### Interactive Menu

```bash
./manage_picoclaw.sh
```

Menu options:

1. Check if Picoclaw is running
2. Start Picoclaw service
3. Stop Picoclaw service
4. Restart Picoclaw service
5. View service status
6. Picoclaw command status
7. Configure Picoclaw (`picoclaw-launcher-tui`)
8. View logs (highlight + filter)
9. Exit

### Command-Line Arguments

```bash
./manage_picoclaw.sh version          # Show script version
./manage_picoclaw.sh check            # Check if Picoclaw is running
./manage_picoclaw.sh start            # Start Picoclaw service
./manage_picoclaw.sh stop             # Stop Picoclaw service
./manage_picoclaw.sh restart          # Restart service
./manage_picoclaw.sh status           # View systemd service status
./manage_picoclaw.sh picoclaw-status  # Run Picoclaw status command
./manage_picoclaw.sh configure        # Launch configuration interface
./manage_picoclaw.sh logs             # View logs with filter
```

---

## Log Viewing

* Logs are stored in `~/.picoclaw/logs`
* Supports filtering:

  * ALL: show all logs (errors and info highlighted)
  * ERROR: only errors
  * WARN: warnings
  * INFO: informational messages

---

## License

[MIT License](LICENSE)

---

## Notes

* The script automatically creates a systemd service `picoclaw` if it does not exist
* All outputs are color-coded for easy identification of errors, warnings, and info
* Designed for SSH or terminal-only environments


