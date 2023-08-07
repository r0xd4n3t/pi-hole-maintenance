#!/bin/bash

# Check if running with root privileges
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script as root (with sudo)." >&2
  exit 1
fi

# Function to log messages
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
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
log "Updating Pi-Hole..."
sudo pihole -up
log "Updating Pi-Hole Gravity..."
pihole -g

# Do apt-get update and upgrade
log "Getting update list..."
sudo apt-get update --fix-missing

log "Upgrading packages..."
sudo apt-get -y upgrade

log "Removing unused packages..."
sudo apt-get -y autoremove

log "Cleaning up..."
sudo apt-get -y autoclean

# Reboot
log "Rebooting..."
sudo systemctl reboot -i

log "Script execution completed successfully."
