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

# setup swarm script
sudo mv -f /tmp/swarm.sh /etc/docker/swarm.sh
sudo chown root:root /etc/docker/swarm.sh
sudo sed -i 's/XX_NODE_TYPE/'${IMAGE_TYPE}'/' /etc/docker/swarm.sh
sudo chmod 750 /etc/docker/swarm.sh
sudo sed -i '/ExecStart=\/usr\/bin\/dockerd/ a ExecStartPost=-/etc/docker/swarm.sh' \
/usr/lib/systemd/system/docker.service && sudo systemctl daemon-reload

exit 0
