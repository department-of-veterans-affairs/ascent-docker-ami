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

sudo groupadd docker
sudo yum-config-manager --enable rhui-REGION-rhel-server-extras
sudo yum -y install docker-latest

#create docker user account
sudo useradd -r -m -g docker docker
#sudo useradd -r -g docker docker
sudo passwd -f -u docker
sudo mkdir -p /app/docker
sudo chown -R docker:docker /app

#install daemon config
sudo mkdir -p /etc/docker-latest
sudo mv -f /tmp/daemon.json /etc/docker-latest/daemon.json
sudo chown root:root /etc/docker-latest/daemon.json

#Install Repository List
sudo mv -f /tmp/registries.conf /etc/containers/registries.conf
sudo chown root:root /etc/containers/registries.conf

#enable docker service
sudo  systemctl enable docker-latest
sudo systemctl start docker-latest


#setup swarm script
sudo mv -f /tmp/swarm.sh /etc/docker-latest/swarm.sh
sudo chown root:root /etc/docker-latest/swarm.sh
sudo sed -i 's/XX_NODE_TYPE/'${IMAGE_TYPE}'/' /etc/docker-latest/swarm.sh
sudo chmod 750 /etc/docker-latest/swarm.sh
sudo sed -i '/ADD_REGISTRY=/ c \
ADD_REGISTRY="--add-registry index.docker.io"' /etc/sysconfig/docker-latest
sudo sed -i '/--authorization-plugin=rhel-push-plugin/ d' /usr/lib/systemd/system/docker-latest.service
sudo sed -i '/LimitNPROC=1048576/ i LimitMEMLOCK=infinity' /usr/lib/systemd/system/docker-latest.service
 sudo sed -i '/ExecReload=\/bin\/kill\ \-s\ HUP\ \$MAINPID/ i ExecStartPost=-/etc/docker-latest/swarm.sh' \
 /usr/lib/systemd/system/docker-latest.service && sudo systemctl daemon-reload
exit 0
