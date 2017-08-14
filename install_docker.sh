#!/bin/bash

trap "exit 2" SIGHUP SIGINT SIGTERM ERR

sudo apt-get update && sudo apt-get -y upgrade

sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

:<<eof
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -

source="\
deb https://apt.dockerproject.org/repo/ \
ubuntu-$(lsb_release -cs) \
main"

echo ${source} | sudo tee /etc/apt/sources.list.d/docker.list
eof

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://mirrors.tuna.tsinghua.edu.cn/docker/apt/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
#proxy_on apt
sudo apt-get update
sudo apt-get -y install docker-engine=1.12.6-0~ubuntu-$(lsb_release -cs)
#proxy_off apt

sudo mv /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/docker.list.bak

#sudo groupadd docker
#sudo usermod -aG docker $USER

