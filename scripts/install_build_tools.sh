#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

## Ansible Variables
tf_version=${TF_VERSION}
key_finger="91A6 E7F8 5D05 C656 30BE  F189 5185 2D87 348F FC4C"

if [[ -z ${tf_version} ]]; then
  echo ""
  echo "${bold}Error:${nobold} No Terraform version set"
  exit 1
fi

## Bolding for Terminal output
bold=$(tput smso)
nobold=$(tput rmso)

## Import Hashicorp GPG key
import_key(){
  gpg --import /tmp/hashicorp.asc

    if [[ "$?" -eq "0" ]]; then
      gpg --finger --list-public-keys |grep "${key_finger}"
        if [[ "$?" -eq "0" ]]; then
          echo ""
          echo "Successfully imported HashiCorp key"
        fi
    else
      echo ""
      echo "${bold}Error:${nobold} Could not import HashiCorp key"
      exit 1
    fi
}

get_files(){
  wget -N https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip \
    -P /opt/src/terraform --quiet
  wget -N https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_SHA256SUMS \
    -P /opt/src/terraform
  wget -N https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_SHA256SUMS.sig \
    -P /opt/src/terraform
}

verify_signature(){
  gpg --status-fd 1 --verify /opt/src/terraform/terraform_${tf_version}_SHA256SUMS.sig |grep GOODSIG

    if [[ "$?" -eq "0" ]]; then
      echo ""
      echo "Verified Signature against public key"
    else
      echo ""
      echo "${bold}Error:${nobold} Could not verify signature with public key"
      exit 1
    fi
}
export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -yq \
  git \
  openjdk-8-jdk \
  packer \
  python-simplejson \
  python-pip \
  unzip \
  maven \
  jq \
  xvfb \
  libgtk-3-dev \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  postgresql-client

pip install pyopenssl --upgrade
pip install awscli --upgrade
pip install boto --upgrade
pip install botocore --upgrade
pip install boto3 --upgrade
sudo -H pip install ansible
sudo apt-get remove -yq requests docopts
pip install requests
pip install docopt

# Create system level symlink so Jenkins can run aws cli
sudo ln -s /home/ubuntu/.local/bin/aws /usr/local/bin/aws

## Install terraform
sudo mkdir -p /opt/src/terraform /opt/jenkins/terraform
sudo chown ${USER}: /opt/src/terraform /opt/jenkins/terraform
import_key
get_files
verify_signature
unzip /opt/src/terraform/terraform_${tf_version}_linux_amd64.zip -d /opt/jenkins/terraform
sudo ln -s /opt/jenkins/terraform/terraform /usr/local/bin/terraform
