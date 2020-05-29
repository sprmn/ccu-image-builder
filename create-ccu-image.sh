#!/bin/bash

pushd stage2-custom/04-ccu-app/files
rm -rf DCU-central-control-app
git clone --single-branch --branch beta https://github.com/MrAlfabet/DCU-central-control-app.git
popd

pushd stage2-custom/06-ccu-server/files
rm -rf ccu-server
git clone --single-branch --branch beta https://github.com/sprmn/ccu-server.git
popd

./build-docker.sh -c ccu.config