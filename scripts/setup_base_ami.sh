#!/bin/bash -x
set -f -o pipefail

# Fix sudo: unable to resolve host ip-XXX-XXX-XXX-XXX
sudo echo "127.0.0.1 $(hostname)" >> /etc/hosts

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
# sudo apt-get dist-upgrade -y

sudo apt-get install -yq \
  unattended-upgrades

if [[ $PYTHON_VERSION == "python3" ]]
then
  sudo apt-get install -yq \
    python3
else
  sudo apt-get install -yq \
    python2.7 # apt-get install python returns error: Package 'python' has no installation candidate
fi