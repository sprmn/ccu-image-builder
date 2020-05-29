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

# Configure crontab
on_chroot << EOF
(crontab -u ${FIRST_USER_NAME} -l; echo "@reboot /usr/bin/python3 /home/${FIRST_USER_NAME}/${app_name}/main.py") | crontab -u ${FIRST_USER_NAME} -
EOF