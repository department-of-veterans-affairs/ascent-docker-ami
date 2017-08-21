#! /bin/bash -e

set -x

echo -e "Docker download urls: $DOCKER_SE_LINUX_PATH \n $DOCKER_PATH"

#Remove potentially pre-loaded version
sudo yum -y remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

#basic packages and prereq
sudo yum -y install wget unzip deltarpm nmap curl
sudo wget -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod 755 /usr/bin/jq
wget $DOCKER_SE_LINUX_PATH
wget $DOCKER_PATH

#install with yum
sudo yum -y install ./docker*selinux*rpm
sudo yum -y install ./docker*x86_64*rpm

#install daemon config
sudo mkdir -p /etc/docker
sudo mv -f /tmp/daemon.json /etc/docker/daemon.json
sudo chown root:root /etc/docker/daemon.json

#enable docker service
sudo  systemctl enable docker
sudo systemctl start docker


exit 0
