#!/bin/bash

ssh -t root@localhost ' /bin/bash -i -c "
  set -e
  snap install kubectl --classic
  apt update && apt -y install apt-transport-https
  proxy_on apt
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
  deb http://apt.kubernetes.io/ kubernetes-xenial main
  EOF
  apt-get update
  apt-get install -y kubelet kubeadm
  proxy_off apt
"'
