#!/bin/bash -e

app_name="ccu-server"

# Copy the latest ccu-server from github in the /home/pi folder
pushd files
find ${app_name} -type f -exec install -D "{}" "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/{}" \;
popd


# Build the app
on_chroot << EOF
cd /home/${FIRST_USER_NAME}/${app_name} && npm i && npm run build
EOF

# Configure ownership
on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

# Configure crontab
on_chroot << EOF
(crontab -u ${FIRST_USER_NAME} -l; echo "@reboot /usr/bin/node /home/${FIRST_USER_NAME}/${app_name}/build") | crontab -u ${FIRST_USER_NAME} -
EOF