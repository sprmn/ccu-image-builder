#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

docker rm -v pigen_work

pushd stage2-custom/04-ccu-app/files
rm -rf DCU-central-control-app
git clone --single-branch --branch temp-offset-control https://github.com/MrAlfabet/DCU-central-control-app.git
popd

pushd stage2-custom/06-ccu-server/files
rm -rf ccu-server
git clone --single-branch --branch temp-offset-control https://github.com/sprmn/ccu-server.git
popd

./build-docker.sh -c ccu.config
