#!/bin/bash

# Check for root privileges
if [[ $(id -u) -ne 0 ]]; then
    echo "Please run this script as root (with sudo)." >&2
    exit 1
fi

# Function to log messages
log() {
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    echo "$timestamp - $1"
}

# Function to handle errors and exit
handle_error() {
    local exit_code="$?"
    log "Error occurred with exit code $exit_code."
    exit "$exit_code"
}

# Trap errors and exit
trap 'handle_error' ERR

# Function to reset logs.log if size is or exceeds 1GB
reset_logfile() {
    local logfile="logs.log"
    local max_size=$((1024 * 1024 * 1024)) # 1GB in bytes

    if [[ -f "$logfile" ]]; then
        local filesize=$(stat -c%s "$logfile")
        if [[ "$filesize" -ge "$max_size" ]]; then
            log "Resetting $logfile as it exceeds 1GB in size."
            > "$logfile" # Truncate the log file
        fi
    fi
}

# Update system packages
update_packages() {
    log "Updating system packages..."
    apt-get update --fix-missing || { log "Failed to update package lists."; exit 1; }
    apt-get -y upgrade || { log "Failed to upgrade packages."; exit 1; }
    apt-get -y autoremove || { log "Failed to remove unused packages."; exit 1; }
    apt-get -y autoclean || { log "Failed to clean package cache."; exit 1; }
}

# Update Pi-Hole (using the full path)
update_pihole() {
    local pihole_cmd=$(which pihole 2>/dev/null)

    if [[ -x "$pihole_cmd" ]]; then
        log "Updating Pi-Hole..."
        "$pihole_cmd" -up || { log "Failed to update Pi-Hole."; exit 1; }
        log "Updating Pi-Hole Gravity..."
        "$pihole_cmd" -g || { log "Failed to update Pi-Hole Gravity."; exit 1; }
    else
        log "Pi-Hole command not found or not executable."
        exit 1
    fi
}

# Reboot the system
reboot_system() {
    log "Rebooting..."
    systemctl reboot -i || { log "Failed to reboot the system."; exit 1; }
}

# Main execution
main() {
    log "Starting script execution..."
    reset_logfile # Check and reset logs.log if necessary
    update_packages
    update_pihole
    log "Script execution completed successfully."
    reboot_system
}

# Run the main function and log the output
main >> logs.log 2>&1
