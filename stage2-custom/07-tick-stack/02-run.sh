#!/bin/bash -e

# Configure tick stack
install -m 644 files/telegraf/telegraf.conf "${ROOTFS_DIR}/etc/telegraf/"
install -m 644 files/influxdb/influxdb.conf "${ROOTFS_DIR}/etc/influxdb/"
mkdir -p "${ROOTFS_DIR}/var/lib/influxdb/meta/"
install -m 644 files/influxdb/meta.db "${ROOTFS_DIR}/var/lib/influxdb/meta/"
install -m 644 files/chronograf/chronograf-v1.db "${ROOTFS_DIR}/var/lib/chronograf/"
install -m 644 files/kapacitor/kapacitor.conf "${ROOTFS_DIR}/etc/kapacitor/"

# Configure permissions
on_chroot << EOF
chown -R telegraf:telegraf /etc/telegraf
chown -R influxdb:influxdb /etc/influxdb
chown -R influxdb:influxdb /var/lib/influxdb
chown -R chronograf:chronograf /var/lib/chronograf
chown -R kapacitor:kapacitor /etc/kapacitor
EOF