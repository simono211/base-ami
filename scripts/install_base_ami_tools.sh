#!/bin/bash -x
set -ef -o pipefail

export DEBIAN_FRONTEND=noninteractive

ansible_version=$ANSIBLE_VERSION
if [[ -z ${ansible_version} ]]
then
  ansible_version="2.7.16"
fi

if [[ $PYTHON_VERSION == "python3" ]]
then
  python_simplejson="python3-simplejson"
  python_pip="python3-pip"
  pip="pip3"
else
  python_simplejson="python-simplejson"
  python_pip="python-pip"
  pip="pip"
fi

sudo apt-get update
sudo apt-get install -y \
  ${python_simplejson} \
  ${python_pip}

#sudo -H ${pip} install pyopenssl --upgrade
sudo -H ${pip} install awscli --upgrade
sudo -H ${pip} install boto --upgrade
sudo -H ${pip} install boto3 --upgrade
sudo -H ${pip} install ansible==${ansible_version}
