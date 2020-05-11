#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo useradd -G sudo -p $(perl -e'print crypt("$1", "$1")') -m -s /bin/bash -N $1
sudo groupadd $1
sudo adduser $1 $1
sudo usermod -aG sudo $1
sudo mkdir -p /home/$1/.ssh/
sudo chown -R $1:$1 /home/$1
