#!/bin/bash

trap "exit 2" SIGHUP SIGINT SIGTERM ERR

CUDA_VERSION=${CUDA_VERSION:-"8.0"}
CUDA_FILE=${CUDA_FILE:-"cuda-repo-ubuntu1404-8-0-local_8.0.44-1_amd64.deb"}
CUDNN_FILE=${CUDNN_FILE:-"cudnn-8.0-linux-x64-v5.1.tgz"}
NVIDIA_DOCKER_FILE=${NVIDIA_DOCKER_FILE:-"nvidia-docker_1.0.0.rc.3-1_amd64.deb"}

SCRIPT_PATH=$(cd `dirname $0`; pwd)

# Update source
sudo cp sources.list /etc/apt
sudo apt-get update
sudo apt-get -y install ubuntu-extras-keyring

# Install some packages
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install vim git make htop nload openssh-client openssh-server \
  bridge-utils nfs-common \
  zlib1g-dev unzip libssl-dev

# Install docker
cd ${SCRIPT_PATH}
./install_docker.sh

# Install cuda
cd ~/Downloads
sudo dpkg -i ${CUDA_FILE}
sudo apt-get update
sudo apt-get -y install cuda

echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.bashrc
echo "export PATH=/usr/local/cuda-${CUDA_VERSION}"'/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc
#cd /usr/local/cuda/samples
#sudo make -j 24

# Install cudnn
cd ~/Downloads
tar xvzf ${CUDNN_FILE}
sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# Install nvidia-docker
cd ~/Downloads
sudo dpkg -i nvidia-docker*.deb
#sudo dpkg -i nvidia-docker*.deb && rm nvidia-docker*.deb
#nvidia-docker run --rm nvidia/cuda nvidia-smi

# Install pyenv
cd ${SCRIPT_PATH}
./install_pyenv.sh
