#!/bin/bash -e

# Enable wifi
COUNTRY=NL
if hash rfkill 2> /dev/null; then
echo "unblocking wifi"
  rfkill unblock wifi
  for filename in /var/lib/systemd/rfkill/*:wlan ; do
    echo "unblocking $filename"
    echo 0 > $filename
  done
fi
