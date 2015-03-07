#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y openjdk-7-jdk
cd /opt
echo 'Downloading Tarfile'
wget -q http://mirrors.ibiblio.org/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
echo 'Downloading done, Extracting'
sudo tar -xzf zookeeper-3.4.6.tar.gz
sudo mv zookeeper-3.4.6 zookeeper
sudo mkdir /opt/zookeeper/data
cat <<EOF > /opt/zookeeper/conf/zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/zookeeper/data
clientPort=2181
server.1=192.168.1.99:2888:3888
EOF
echo 'Starting ZooKeeper'
sudo zookeeper/bin/zkServer.sh start
