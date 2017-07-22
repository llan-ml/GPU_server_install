#!/bin/bash

set -e

remote_node="llan@192.168.239.145"
sources_list="${HOME}/Desktop/sources.list"
HTTP_HOST="219.245.186.233"
HTTP_PORT="8087"
HTTPS_HOST="219.245.186.233"
HTTPS_PORT="8087"

CUDA_VERSION="8.0"
CUDA_FILE="cuda-repo-ubuntu1404-8-0-local_8.0.44-1_amd64.deb"
CUDNN_FILE="cudnn-8.0-linux-x64-v5.1.tgz"
NVIDIA_DOCKER_FILE="nvidia-docker_1.0.0.rc.3-1_amd64.deb"

ANACONDA_VERSION="anaconda2-4.4.0"
ANACONDA_FILE="Anaconda2-4.4.0-Linux-x86_64.sh"

scp ${sources_list} ${remote_node}:~/
ssh -t ${remote_node} ' /bin/bash -i -c "
  set -e
  sudo sed -i 's/^\(PermitRootLogin \)[a-zA-Z-]*$/\1yes/g' /etc/ssh/sshd_config
  sudo systemctl restart ssh.service
  sudo mv ~/sources.list /etc/apt/
  sudo apt update && sudo apt -y upgrade
  sudo apt -y install git
  git clone --depth 1 https://github.com/llan-ml/AutoProxy.git
  git clone --depth 1 https://github.com/llan-ml/GPU_server_install.git
  pushd AutoProxy
  '"echo -e '\
export HTTP_HOST=${HTTP_HOST} 
export HTTP_PORT=${HTTP_PORT}
export HTTPS_HOST=${HTTPS_HOST} 
export HTTPS_PORT=${HTTPS_PORT}'"' > proxy_setting.sh
  bash initialize.sh
  popd
"'

ssh -t ${remote_node} " /bin/bash -i -c '
  set -e
  export CUDA_VERSION=8.0
  export CUDA_FILE=${CUDA_FILE}
  export CUDNN_FILE=${CUDNN_FILE}
  export NVIDIA_DOCKER_FILE=${NVIDIA_DOCKER_FILE}

  export ANACONDA_VERSION=${ANACONDA_VERSION}
  export ANACONDA_FILE=${ANACONDA_FILE}
  export remote_node=${remote_node}
  pushd GPU_server_install
  ./script.sh
  popd
'"

# Install kubectl
ssh -t ${remote_node:-""} ' /bin/bash -i -c "
  set -e
  sudo snap install kubectl --classic
#  echo 'source <(kubectl completion bash)' >> ~/.bashrc
"'
# Install kubelet and kubeadm
ssh -t root@localhost ' /bin/bash -i -c "
  set -e
  apt update && apt -y install apt-transport-https
  proxy_on apt
  proxy_on bash
  source \${HOME}/.bashrc
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
  apt-get update
  apt-get install -y kubelet kubeadm
  proxy_off apt
  proxy_off bash
"'
