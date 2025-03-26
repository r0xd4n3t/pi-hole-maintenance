#!/usr/bin/env bash

# Configuration
LOG_FILE="/root/logs.log"
MAX_LOG_SIZE=$((1 * 1024 * 1024 * 1024))  # 1GB
LOG_BACKUPS=3                              # Number of log backups to keep
ENABLE_REBOOT="auto"                       # auto, always, never
LOCK_FILE="/tmp/pi_hole_updater.lock"

# Exit immediately on errors, unset variables, and pipeline failures
set -euo pipefail

# Check for root privileges
if [[ $(id -u) -ne 0 ]]; then
    echo "ERROR: This script must be run as root" >&2
    exit 1
fi

# Create lock file or exit if already running
if ! (set -C; echo $$ > "$LOCK_FILE") 2>/dev/null; then
    echo "ERROR: Script already running (PID $(<"$LOCK_FILE"))" >&2
    exit 1
fi
trap 'rm -f "$LOCK_FILE"; exit' EXIT

# Function to log messages
log() {
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    echo "$timestamp - $1" >> "$LOG_FILE"
}

# Error handling with line number
handle_error() {
    local exit_code=$?
    local line_no=$1
    log "ERROR: Command failed at line $line_no with exit code $exit_code"
    exit "$exit_code"
}
trap 'handle_error $LINENO' ERR

# Rotate logs if needed
rotate_logs() {
    if [[ -f "$LOG_FILE" ]]; then
        local filesize=$(stat -c%s "$LOG_FILE")
        if (( filesize >= MAX_LOG_SIZE )); then
            log "Rotating log file (size: $filesize bytes)"
            for ((i=LOG_BACKUPS; i>0; i--)); do
                local src="${LOG_FILE}.$((i-1))"
                local dst="${LOG_FILE}.$i"
                [[ -f "$src" ]] && mv -f "$src" "$dst"
            done
            mv -f "$LOG_FILE" "${LOG_FILE}.0"
        fi
    fi
}

# Fix corrupted APT lists
fix_apt_lists() {
    log "Checking for corrupted APT lists..."
    if grep -q "Encountered a section with no Package" /var/log/apt/*; then
        log "Corrupted APT lists detected. Cleaning..."
        rm -rf /var/lib/apt/lists/*
        apt-get clean
    fi
}

# Update system packages
update_packages() {
    log "Starting system update..."
    fix_apt_lists
    DEBIAN_FRONTEND=noninteractive apt-get update -qq --fix-missing
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -qq
    DEBIAN_FRONTEND=noninteractive apt-get autoclean -qq
    log "System update completed successfully"
}

# Update Pi-Hole components
update_pihole() {
    local pihole_cmd=$(command -v pihole)

    if [[ -x "$pihole_cmd" ]]; then
        log "Starting Pi-Hole update..."
        "$pihole_cmd" -up -y || { log "Pi-Hole update failed"; return 1; }
        log "Updating Gravity database..."
        "$pihole_cmd" -g -y || { log "Gravity update failed"; return 1; }
        log "Pi-Hole updates completed successfully"
    else
        log "ERROR: Pi-Hole not found or not executable"
        return 1
    fi
}

# Check if reboot is required
check_reboot() {
    case $ENABLE_REBOOT in
        "always")
            log "Reboot requested by configuration"
            return 0
            ;;
        "auto")
            if [[ -f "/var/run/reboot-required" ]]; then
                log "Reboot required detected"
                return 0
            fi
            ;;
    esac
    log "No reboot required"
    return 1
}

# Main execution flow
main() {
    rotate_logs
    log "=== Starting Pi-Hole maintenance ==="

    update_packages
    update_pihole

    if check_reboot; then
        log "Initiating system reboot..."
        sync
        systemctl reboot
    fi

    log "=== Maintenance completed successfully ==="
}

# Start main process and handle logging
main
