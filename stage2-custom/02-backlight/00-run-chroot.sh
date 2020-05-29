#!/bin/bash -e

# Install python rpi_backlight lib
python3 -m pip install rpi_backlight

# Set correct permissions
echo 'SUBSYSTEM=="backlight",RUN+="/bin/chmod 666 /sys/class/backlight/%k/brightness /sys/class/backlight/%k/bl_power"' >> /etc/udev/rules.d/backlight-permissions.rules