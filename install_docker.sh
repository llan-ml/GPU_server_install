#!/bin/bash

trap "exit 2" SIGHUP SIGINT SIGTERM ERR

sudo apt-get update && sudo apt-get -y upgrade

sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -

source="\
deb https://apt.dockerproject.org/repo/ \
ubuntu-$(lsb_release -cs) \
main"

echo ${source} | sudo tee /etc/apt/sources.list.d/docker.list

proxy_on apt
sudo apt-get update
sudo apt-get -y install docker-engine=1.12.6-0~ubuntu-$(lsb_release -cs)
proxy_off apt

sudo groupadd docker
sudo usermod -aG docker $USER

curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://89e6dbca.m.daocloud.io
