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

# setup swarm script
sudo mv -f /tmp/swarm.sh /etc/docker/swarm.sh
sudo chown root:root /etc/docker/swarm.sh
sudo sed -i 's/XX_NODE_TYPE/'${IMAGE_TYPE}'/' /etc/docker/swarm.sh
sudo chmod 750 /etc/docker/swarm.sh
sudo sed -i '/ExecStart=\/usr\/bin\/dockerd/ a ExecStartPost=-/etc/docker/swarm.sh' \
/usr/lib/systemd/system/docker.service && sudo systemctl daemon-reload


exit 0
