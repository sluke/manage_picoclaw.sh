# Picoclaw Management Script

**Version:** 1.1

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
2. Start Picoclaw service (gateway)
3. Stop Picoclaw service
4. Restart Picoclaw service
5. View service status
6. Picoclaw command status
7. Configure Picoclaw (`picoclaw-launcher-tui`)
8. View logs (highlight + filter)
9. Run 'picoclaw agent'
10. Run 'picoclaw auth'
11. Run 'picoclaw cron'
12. Run 'picoclaw migrate'
13. Run 'picoclaw model'
14. Run 'picoclaw onboard'
15. Run 'picoclaw skills'
16. Run 'picoclaw update'
17. Run 'picoclaw completion'
18. Run 'picoclaw help'
0. Exit

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
./manage_picoclaw.sh agent [args]     # Interact with the agent directly
./manage_picoclaw.sh auth [args]      # Manage authentication
./manage_picoclaw.sh completion [args]# Generate the autocompletion script
./manage_picoclaw.sh cron [args]      # Manage scheduled tasks
./manage_picoclaw.sh gateway          # Start picoclaw gateway (same as start)
./manage_picoclaw.sh help [args]      # Help about any command
./manage_picoclaw.sh migrate [args]   # Migrate to picoclaw
./manage_picoclaw.sh model [args]     # Show or change the default model
./manage_picoclaw.sh onboard [args]   # Initialize configuration and workspace
./manage_picoclaw.sh skills [args]    # Manage skills
./manage_picoclaw.sh update [args]    # Check and apply updates
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


