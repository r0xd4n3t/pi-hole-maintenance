<a id="top"></a>

#

<h1 align="center">
Pi-Hole Updater and System Maintenance Script
</h1>

<p align="center"> 
  <kbd>
<img src="https://raw.githubusercontent.com/r0xd4n3t/pi-hole-maintenance/main/img/pi-main.png"></img>
  </kbd>
</p>

<p align="center">
<img src="https://img.shields.io/github/last-commit/r0xd4n3t/pi-hole-maintenance?style=flat">
<img src="https://img.shields.io/github/stars/r0xd4n3t/pi-hole-maintenance?color=brightgreen">
<img src="https://img.shields.io/github/forks/r0xd4n3t/pi-hole-maintenance?color=brightgreen">
</p>

# 📜 Introduction
This Bash script automates the process of updating and maintaining a Raspberry Pi running Pi-Hole, a network-wide ad blocker. It ensures that your Pi-Hole software is up to date and performs routine system maintenance tasks for optimal performance.

> Features:

-    Checks for root privileges to ensure proper execution.
-    Automates the update of Pi-Hole software and its gravity list.
-    Updates the system's package list and performs package upgrades, cleaning, and removal of unused packages.
-    Reboots the system after updates for changes to take effect.
-    Handles errors gracefully and provides informative logs.

## 🕹️ Usage
1. Clone this repository to your Raspberry Pi.
2. Make the script executable: chmod +x pi_hole_updater.sh
3. Run the script with root privileges: sudo ./pi_hole_updater.sh

## 📝 Note
1. This script assumes you have Pi-Hole and Bash installed on your Raspberry Pi.
2. Running this script will update Pi-Hole and perform system maintenance tasks, including a system reboot.

You also can put in crontab and set it to run every monday @9am. Example:

```
chmod +x pi_hole_updater.sh
```

```
# auto update and reboot every monday @ 9am
0 9 * * 1 /home/pi_hole/pi_hole_updater.sh
```

Feel free to customize and extend this script according to your specific needs.

Please use responsibly and take caution while performing updates and maintenance on your system.


<p align="center"><a href=#top>Back to Top</a></p>
