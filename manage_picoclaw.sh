#!/bin/bash

# ===============================================
# Picoclaw Management Script (Final Version with Highlight + Log Filter)
# Version: 1.0
# Place in the same directory as picoclaw executable
# ===============================================

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
PICOCLAW_PATH="$SCRIPT_DIR"
SERVICE_NAME=picoclaw
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
LOG_DIR="$HOME/.picoclaw/logs"
SCRIPT_VERSION="1.0"

# ----------------------------
# ANSI Colors
# ----------------------------
RED="\033[31m"
YELLOW="\033[33m"
GREEN="\033[32m"
RESET="\033[0m"

# ----------------------------
# Highlight Output
# ----------------------------
function highlight_output() {
    while IFS= read -r line; do
        if [[ $line =~ [Ee][Rr][Rr]|[Ff]ail ]]; then
            echo -e "${RED}$line${RESET}"
        elif [[ $line =~ [Ww]arn|WARNING ]]; then
            echo -e "${YELLOW}$line${RESET}"
        elif [[ $line =~ ok|INFO|active ]]; then
            echo -e "${GREEN}$line${RESET}"
        else
            echo "$line"
        fi
    done
}

# ----------------------------
# Display version
# ----------------------------
function show_version() {
    echo -e "${GREEN}Picoclaw Management Script Version: $SCRIPT_VERSION${RESET}"
}

# ----------------------------
# Check if Picoclaw is running
# ----------------------------
function check_running() {
    PROC_LIST=$(pgrep -af "$PICOCLAW_PATH/picoclaw")
    if [[ -z "$PROC_LIST" ]]; then
        echo -e "${YELLOW}Picoclaw is not running${RESET}"
    else
        echo -e "${GREEN}Running Picoclaw processes:${RESET}"
        echo "$PROC_LIST" | highlight_output
    fi
}

# ----------------------------
# Create systemd service
# ----------------------------
function create_service() {
    if [ ! -f "$SERVICE_FILE" ]; then
        echo "Creating systemd service file: $SERVICE_FILE"
        sudo bash -c "cat > $SERVICE_FILE <<EOF
[Unit]
Description=Picoclaw Gateway Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$PICOCLAW_PATH
ExecStart=$PICOCLAW_PATH/picoclaw gateway
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF"
        sudo systemctl daemon-reload
        sudo systemctl enable $SERVICE_NAME
        echo -e "${GREEN}Service created: $SERVICE_NAME${RESET}"
    fi
}

# ----------------------------
# Systemd service operations
# ----------------------------
function start_service() {
    create_service
    sudo systemctl start $SERVICE_NAME 2>&1 | highlight_output
    echo -e "${GREEN}Picoclaw service started${RESET}"
}

function stop_service() {
    sudo systemctl stop $SERVICE_NAME 2>&1 | highlight_output
    echo -e "${YELLOW}Picoclaw service stopped${RESET}"
}

function restart_service() {
    sudo systemctl restart $SERVICE_NAME 2>&1 | highlight_output
    echo -e "${GREEN}Picoclaw service restarted${RESET}"
}

function status_service() {
    sudo systemctl status $SERVICE_NAME 2>&1 | highlight_output
}

# ----------------------------
# Picoclaw command status
# ----------------------------
function picoclaw_status() {
    $PICOCLAW_PATH/picoclaw status 2>&1 | highlight_output
}

# ----------------------------
# Launch Picoclaw configuration interface
# ----------------------------
function configure_picoclaw() {
    if [ -x "$PICOCLAW_PATH/picoclaw-launcher-tui" ]; then
        "$PICOCLAW_PATH/picoclaw-launcher-tui"
    else
        echo -e "${RED}picoclaw-launcher-tui not found or not executable${RESET}"
    fi
}

# ----------------------------
# View logs with highlight + filter
# ----------------------------
function view_logs() {
    if [ ! -d "$LOG_DIR" ]; then
        echo -e "${RED}Log directory does not exist: $LOG_DIR${RESET}"
        return
    fi

    echo "Select a log file:"
    select log_file in $(ls "$LOG_DIR"); do
        [[ -n "$log_file" ]] || { echo "Invalid selection"; continue; }

        echo "Select filter mode:"
        select filter in "ALL" "ERROR" "WARN" "INFO"; do
            [[ -n "$filter" ]] || { echo "Invalid selection"; continue; }
            echo -e "${GREEN}Press Ctrl+C to exit log view${RESET}"

            tail -f "$LOG_DIR/$log_file" | while IFS= read -r line; do
                case "$filter" in
                    ALL)
                        if [[ $line =~ ERROR|ERR ]]; then
                            echo -e "${RED}$line${RESET}"
                        elif [[ $line =~ WARN ]]; then
                            echo -e "${YELLOW}$line${RESET}"
                        elif [[ $line =~ INFO ]]; then
                            echo -e "${GREEN}$line${RESET}"
                        else
                            echo "$line"
                        fi
                        ;;
                    ERROR)
                        if [[ $line =~ ERROR|ERR ]]; then
                            echo -e "${RED}$line${RESET}"
                        fi
                        ;;
                    WARN)
                        if [[ $line =~ WARN ]]; then
                            echo -e "${YELLOW}$line${RESET}"
                        fi
                        ;;
                    INFO)
                        if [[ $line =~ INFO ]]; then
                            echo -e "${GREEN}$line${RESET}"
                        fi
                        ;;
                esac
            done
            break
        done
        break
    done
}

# ----------------------------
# Interactive menu
# ----------------------------
function interactive_menu() {
    show_version
    while true; do
        echo "================ Picoclaw Management Menu ================"
        echo "1) Check if Picoclaw is running"
        echo "2) Start Picoclaw service (gateway)"
        echo "3) Stop Picoclaw service"
        echo "4) Restart Picoclaw service"
        echo "5) View service status"
        echo "6) Picoclaw command status"
        echo "7) Configure Picoclaw"
        echo "8) View logs (highlight + filter)"
        echo "9) Run 'picoclaw agent'"
        echo "10) Run 'picoclaw auth'"
        echo "11) Run 'picoclaw cron'"
        echo "12) Run 'picoclaw migrate'"
        echo "13) Run 'picoclaw model'"
        echo "14) Run 'picoclaw onboard'"
        echo "15) Run 'picoclaw skills'"
        echo "16) Run 'picoclaw update'"
        echo "17) Run 'picoclaw completion'"
        echo "18) Run 'picoclaw help'"
        echo "0) Exit"
        read -p "Select an option: " choice
        case $choice in
            1) check_running ;;
            2) start_service ;;
            3) stop_service ;;
            4) restart_service ;;
            5) status_service ;;
            6) picoclaw_status ;;
            7) configure_picoclaw ;;
            8) view_logs ;;
            9) $PICOCLAW_PATH/picoclaw agent ;;
            10) $PICOCLAW_PATH/picoclaw auth ;;
            11) $PICOCLAW_PATH/picoclaw cron ;;
            12) $PICOCLAW_PATH/picoclaw migrate ;;
            13) $PICOCLAW_PATH/picoclaw model ;;
            14) $PICOCLAW_PATH/picoclaw onboard ;;
            15) $PICOCLAW_PATH/picoclaw skills ;;
            16) $PICOCLAW_PATH/picoclaw update ;;
            17) $PICOCLAW_PATH/picoclaw completion ;;
            18) $PICOCLAW_PATH/picoclaw help ;;
            0) exit 0 ;;
            *) echo -e "${RED}Invalid selection${RESET}" ;;
        esac
        echo ""
    done
}

# ----------------------------
# Command-line argument support
# ----------------------------
if [[ $# -eq 0 ]]; then
    interactive_menu
else
    case "$1" in
        version) show_version ;;
        check) check_running ;;
        start) start_service ;;
        stop) stop_service ;;
        restart) restart_service ;;
        status) status_service ;;
        picoclaw-status) picoclaw_status ;;
        configure) configure_picoclaw ;;
        logs) view_logs ;;
        agent) shift; $PICOCLAW_PATH/picoclaw agent "$@" ;;
        auth) shift; $PICOCLAW_PATH/picoclaw auth "$@" ;;
        completion) shift; $PICOCLAW_PATH/picoclaw completion "$@" ;;
        cron) shift; $PICOCLAW_PATH/picoclaw cron "$@" ;;
        gateway) start_service ;;
        help) shift; $PICOCLAW_PATH/picoclaw help "$@" ;;
        migrate) shift; $PICOCLAW_PATH/picoclaw migrate "$@" ;;
        model) shift; $PICOCLAW_PATH/picoclaw model "$@" ;;
        onboard) shift; $PICOCLAW_PATH/picoclaw onboard "$@" ;;
        skills) shift; $PICOCLAW_PATH/picoclaw skills "$@" ;;
        update) shift; $PICOCLAW_PATH/picoclaw update "$@" ;;
        *) echo -e "${RED}Unknown command${RESET}" ;;
    esac
fi
