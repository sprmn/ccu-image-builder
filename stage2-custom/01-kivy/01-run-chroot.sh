#!/bin/bash -e

# Install prerequisites
python3 -m pip install pip setuptools
python3 -m pip install Cython==0.29.10 pillow

# Install kivy
python3 -m pip install kivy

# Generate default config file in home dir
runuser -l ${FIRST_USER_NAME} -c "python3 -c 'import kivy'"
