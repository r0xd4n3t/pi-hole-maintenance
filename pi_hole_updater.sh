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

# Update system packages
update_packages() {
    log "Updating system packages..."
    apt-get update --fix-missing
    apt-get -y upgrade
    apt-get -y autoremove
    apt-get -y autoclean
}

# Update Pi-Hole
update_pihole() {
    log "Updating Pi-Hole..."
    pihole -up
    log "Updating Pi-Hole Gravity..."
    pihole -g
}

# Reboot the system
reboot_system() {
    log "Rebooting..."
    systemctl reboot -i
}

# Main execution
main() {
    update_packages
    update_pihole
    log "Script execution completed successfully."
    reboot_system
}

# Run the main function and log the output
main >> logs.log 2>&1

