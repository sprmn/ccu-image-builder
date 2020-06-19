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

# Install pm2
on_chroot << EOF
npm i -g pm2
EOF

# Configure pm2 to start at boot
on_chroot << EOF
env PATH=$PATH:/usr/bin pm2 startup systemd -u ${FIRST_USER_NAME} --hp /home/${FIRST_USER_NAME}
EOF

# Add our app to pm2 services
on_chroot << EOF
su - ${FIRST_USER_NAME} -c "pm2 start /home/${FIRST_USER_NAME}/${app_name}/build && pm2 save && pm2 kill"
EOF

# Setup logrotation
on_chroot << EOF
pm2 logrotate -u ${FIRST_USER_NAME} && pm2 kill
EOF
