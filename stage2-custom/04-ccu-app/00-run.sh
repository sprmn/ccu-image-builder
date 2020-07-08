#!/bin/bash -e

app_name="DCU-central-control-app"

# Copy the latest DCU-central-control-app from github in the /home/pi folder
pushd files
find ${app_name} -type f -exec install -D "{}" "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/{}" \;
popd

# Configure ownership
on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

# Install ccu-app service
install -m 644 files/ccu-app.service	"${ROOTFS_DIR}/etc/systemd/system/"
on_chroot << EOF
systemctl enable ccu-app
EOF
