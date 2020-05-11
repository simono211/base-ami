#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install Docker CE
sudo apt-get install -yq \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt-cache policy docker-ce
sudo apt-get install -yq \
  docker-ce \
  docker-compose

# Work around for docker/ubuntu 18.04 bug
sudo mv /usr/bin/docker-credential-secretservice /usr/bin/docker-credential-secretservice.not