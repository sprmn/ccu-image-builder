#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# Install required packages
apt install -y hostapd dnsmasq

# Default values
SUBNET=${SUBNET:-192.168.254.0}
AP_ADDR=${AP_ADDR:-192.168.254.1}
CHANNEL=${CHANNEL:-11}
NUMBER=${NUMBER:-61}
SSID=`printf 'TegnisControlNetwork%08d' $NUMBER`
WPA_PASSPHRASE=`node -p "2**32-1-${NUMBER}"`

# Configure hostapd
cat > "/etc/hostapd/hostapd.conf" <<EOF
ssid=${SSID}
wpa_passphrase=${WPA_PASSPHRASE}
interface=wlan0
hw_mode=g
channel=11
wpa=2
wpa_key_mgmt=WPA-PSK
# TKIP is no secure anymore
#wpa_pairwise=TKIP CCMP
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_ptk_rekey=600
wmm_enabled=1
EOF

# Configure static ip
mv /etc/dhcpcd.conf /etc/dhcpcd.confg.orig
cat > "/etc/dhcpcd.conf" <<EOF
interface wlan0
static ip_address=${AP_ADDR}/24
EOF

# Patch /etc/default/hostapd:
mv /etc/default/hostapd /etc/default/hostapd.orig
echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' > /etc/default/hostapd

# Configure dnsmasq as dhcp server
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
cat > "/etc/dnsmasq.conf" <<EOF
interface=wlan0
  dhcp-range=${SUBNET::-1}100,${SUBNET::-1}200,255.255.255.0,24h
EOF

# Disable wifi
if [ -f "/etc/wpa_supplicant/wpa_supplicant.conf" ] ; then
  mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig
else
  cat > "/etc/wpa_supplicant/wpa_supplicant.conf" <<EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=nl
EOF

fi

# Enable and start service
systemctl unmask hostapd
systemctl unmask dnsmasq
systemctl enable hostapd
systemctl enable dnsmasq
systemctl restart dhcpcd
systemctl start hostapd
systemctl start dnsmasq

