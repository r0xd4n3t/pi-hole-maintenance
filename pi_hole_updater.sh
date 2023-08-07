#!/bin/bash

# Check if running with root privileges
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

# Update Pi-Hole
update_pihole() {
  log "Updating Pi-Hole..."
  sudo pihole -up
  log "Updating Pi-Hole Gravity..."
  pihole -g
}

# Update system packages
update_packages() {
  log "Getting update list..."
  sudo apt-get update --fix-missing

  log "Upgrading packages..."
  sudo apt-get -y upgrade

  log "Removing unused packages..."
  sudo apt-get -y autoremove

  log "Cleaning up..."
  sudo apt-get -y autoclean
}

# Reboot the system
reboot_system() {
  log "Rebooting..."
  sudo systemctl reboot -i
}

# Main execution
main() {
  update_pihole
  update_packages
  reboot_system

  log "Script execution completed successfully."
}

# Run the main function
main >> logs.log 2>&1
