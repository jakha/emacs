#!/bin/bash

sudo apt update
sudo apt install git-delta

sudo apt install -y build-essential cmake libtool-bin pkg-config libvterm-dev socat

sudo apt install -y locales
sudo locale-gen en_US.UTF-8 ru_RU.UTF-8
sudo update-locale LANG=en_US.UTF-8


# to open mosh ports sudo ufw allow 60000:60005/udp
