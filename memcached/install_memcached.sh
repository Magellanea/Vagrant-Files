#!/usr/bin/env bash
echo "Installing Memcached - building from source"
sudo apt-get -y install libevent-dev build-essential
wget http://memcached.org/files/memcached-1.4.21.tar.gz
tar -zxvf memcached-1.4.21.tar.gz
cd memcached-1.4.21
./configure && make && sudo make install
memcached
