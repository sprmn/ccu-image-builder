#!/bin/bash -e

(echo "@reboot /usr/bin/python3 /home/${FIRST_USER_NAME}/DCU-central-control-app/main.py"; echo "@reboot /usr/bin/node /home/${FIRST_USER_NAME}/ccu-server/build") | crontab -u ${FIRST_USER_NAME} -