#! /bin/bash -e

set -x

echo ${DOCKER_BASE_URL}

DOCKER_VERSION=17.03

DOCKER_PACKAGE_NAME=docker-ee-17.03.2.ee.4-1.el7.centos.x86_64.rpm
DOCKER_SELINUX_PKG_NAME=docker-ee-selinux-17.03.2.ee.4-1.el7.centos.noarch.rpm

#Remove potentially pre-loaded version
sudo yum -y remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

#basic packages and prereq
sudo yum -y install wget unzip deltarpm 

#get docker rpm
wget ${DOCKER_BASE_URL}/rhel/7/x86_64/stable-${DOCKER_VERSION}/Packages/${DOCKER_PACKAGE_NAME}
wget ${DOCKER_BASE_URL}/rhel/7/x86_64/stable-${DOCKER_VERSION}/Packages/${DOCKER_SELINUX_PKG_NAME}

#install with yum
sudo yum -y install ./${DOCKER_SELINUX_PKG_NAME}
sudo yum -y install ./${DOCKER_PACKAGE_NAME}

#install daemon config
sudo mkdir -p /etc/docker
sudo mv -f /tmp/daemon.json /etc/docker/daemon.json
sudo chown root:root /etc/docker/daemon.json

#enable docker service
sudo  systemctl enable docker

exit 0
