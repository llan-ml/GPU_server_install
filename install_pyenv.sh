#!/bin/bash

trap "exit 2" SIGHUP SIGINT SIGTERM ERR

ANACONDA_VERSION="anaconda2-4.1.1"
ANACONDA_FILE="Anaconda2-4.1.1-Linux-x86_64.sh"

CA_PATH=""

# Install pyenv
cd ${HOME}
proxy_on bash
curl -L --cacert ${CA_PATH} https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
proxy_off bash

export PATH="/home/lanlin/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install anaconda
mkdir -p ~/.pyenv/cache
cp ~/Downloads/${ANACONDA_FILE} ~/.pyenv/cache
pyenv install ${ANACONDA_VERSION}

# Install tensorflow, tensorlayer
pyenv activate ${ANACONDA_VERSION}
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
export PIP_INDEX_URL=http://pypi.douban.com/simple/
export PIP_TRUSTED_HOST=pypi.douban.com

pip install tensorflow-gpu
pip install tensorlayer

#conda remove -y mkl mkl-service
#conda install -y nomkl numpy scipy scikit-learn numexpr

pyenv deactivate

echo 'export PATH="/home/lanlin/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
echo "" >> ~/.bashrc
echo 'export PIP_INDEX_URL=http://pypi.douban.com/simple/' >> ~/.bashrc
echo 'export PIP_TRUSTED_HOST=pypi.douban.com' >> ~/.bashrc
echo "" >> ~/.bashrc