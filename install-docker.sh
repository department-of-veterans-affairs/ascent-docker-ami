#! /bin/bash -e

set -x

#Remove potentially pre-loaded version
sudo yum -y remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

#basic packages and prereq
sudo yum -y install wget unzip deltarpm curl
sudo wget -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod 755 /usr/bin/jq

sudo groupadd docker
sudo yum-config-manager --enable rhui-REGION-rhel-server-extras
sudo yum -y install docker

#create docker user account, don't create home directory to preserve ssh security in AWS
#sudo useradd -r -m -g docker docker
sudo useradd -r -g docker docker
sudo passwd -f -u docker
sudo mkdir -p /app/docker
sudo chown -R docker:docker /app

#install daemon config
sudo mkdir -p /etc/docker
sudo mv -f /tmp/daemon.json /etc/docker/daemon.json
sudo chown root:root /etc/docker/daemon.json

#enable docker service
sudo  systemctl enable docker
sudo systemctl start docker


exit 0
