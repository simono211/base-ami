#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

ver=2.0.2

sudo apt-get update
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
sudo apt-get install -yq \
  build-essential \
  dkms

git clone https://github.com/amzn/amzn-drivers
sudo mv amzn-drivers /usr/src/amzn-drivers-"$ver"
sudo touch /usr/src/amzn-drivers-"$ver"/dkms.conf

echo "PACKAGE_NAME=\"ena\"
PACKAGE_VERSION=\"$ver\"
CLEAN=\"make -C kernel/linux/ena clean\"
MAKE=\"make -C kernel/linux/ena/ BUILD_KERNEL=\${kernelver}\"
BUILT_MODULE_NAME[0]=\"ena\"
BUILT_MODULE_LOCATION=\"kernel/linux/ena\"
DEST_MODULE_LOCATION[0]=\"/updates\"
DEST_MODULE_NAME[0]=\"ena\"
AUTOINSTALL=\"yes\"" | sudo tee -a /usr/src/amzn-drivers-"$ver"/dkms.conf

sudo cat /usr/src/amzn-drivers-"$ver"/dkms.conf

sudo dkms add -m amzn-drivers -v "$ver"
sudo dkms build -m amzn-drivers -v "$ver"
sudo dkms install -m amzn-drivers -v "$ver"
