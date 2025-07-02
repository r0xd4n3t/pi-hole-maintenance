<a id="top"></a>

<h1 align="center">
Pi-Hole Updater and System Maintenance Script
</h1>

<p align="center">
  <kbd>
    <img src="https://raw.githubusercontent.com/r0xd4n3t/pi-hole-maintenance/main/img/pi-main.png" alt="Pi-Hole Maintenance Banner">
  </kbd>
</p>

<p align="center">
  <img src="https://img.shields.io/github/last-commit/r0xd4n3t/pi-hole-maintenance?style=flat">
  <img src="https://img.shields.io/github/stars/r0xd4n3t/pi-hole-maintenance?color=brightgreen">
  <img src="https://img.shields.io/github/forks/r0xd4n3t/pi-hole-maintenance?color=brightgreen">
</p>

---

## 📜 Introduction

This Bash script automates the process of updating and maintaining a Raspberry Pi or Debian-based system running **Pi-hole**, a network-wide ad blocker. It ensures that Pi-hole is up to date and performs routine system maintenance for stability and performance.

### ✅ Features
- Ensures the script is run as root (privilege check).
- Verifies that the OS is Debian-based or Raspberry Pi OS.
- Automatically updates Pi-hole and its gravity database.
- Updates system packages with `apt-get update && full-upgrade`.
- Performs cleanup with `autoremove` and `autoclean`.
- Checks if a reboot is required and performs it automatically.
- Timestamps all logs and rotates them (up to 5 backups).

---

## 🕹️ Usage

1. Clone this repository to your system:
```
git clone https://github.com/r0xd4n3t/pi-hole-maintenance.git
cd pi-hole-maintenance
```

2. Make the script executable:
```
chmod +x pi_hole_updater.sh
```

3. Run the script with root privileges:
```
sudo ./pi_hole_updater.sh
```

## 📅 Automate with Cron

To run the script automatically every Monday at 9:00 AM, add the following to your crontab:
```
sudo crontab -e
```
Then add this line:
```
0 9 * * 1 /path/to/pi_hole_updater.sh
```
> Replace /path/to/pi_hole_updater.sh with the full path to your script (e.g., /home/pi/pi-hole-maintenance/pi_hole_updater.sh).

## 📝 Note

-    This script assumes bash, apt, and pihole are installed and accessible.
-    It is designed for Raspberry Pi OS or any Debian-based distribution.
-    If pihole is not installed, the script will skip Pi-hole-specific updates.
-    Logs are written to logs.log in the script directory and rotated automatically.

## ⚠️ Disclaimer
> Use this script at your own risk. Automated updates and reboots may disrupt active sessions or services. Always test in a staging environment before deploying to production systems.

Feel free to customize and extend this script according to your specific needs.

Please use responsibly and take caution while performing updates and maintenance on your system.

<p align="center"><a href=#top>Back to Top</a></p>
