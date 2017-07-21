#!/bin/bash

trap "exit 2" SIGHUP SIGINT SIGTERM ERR

PYTHON_FILE="Python-2.7.12.tgz"
SETUPTOOLS_FILE="setuptools-32.1.2.zip"
PIP_FILE="pip-9.0.1.tar.gz"

# Install python
cd ~/Downloads
tar -zxf ${PYTHON_FILE}
cd Python-*
./configure
make
sudo make install
echo 'export PYTHONPATH=/usr/local/lib/python2.7/dist-packages:$PYTHONPATH' >> ~/.bashrc
source ~/.bashrc

# Install setuptools
cd ~/Downloads
unzip ${SETUPTOOLS_FILE}
cd ~/Downloads/setuptools-*
sudo python setup.py build
sudo python setup.py install

# Install pip
cd ~/Downloads
tar -zxf ${PIP_FILE}
cd ~/Downloads/pip-*
sudo python setup.py build
sudo python setup.py install
cd ~/
mkdir -p ~/.pip
cd ~/.pip
echo -e "[global]\ntimeout=40\nindex-url=http://pypi.douban.com/simple/\n[install]\ntrusted-host=pypi.douban.com" > ./pip.conf

cd ~/
sudo pip install jsonpath-rw PyYAML jinja2
