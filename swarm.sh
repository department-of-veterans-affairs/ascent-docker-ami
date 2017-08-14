#!/bin/bash -ex


[[ -z "$DOCKER_SWARM_TOKEN" ]] && echo "Initializing swarm" && sudo docker swarm init | sudo tee  /etc/docker/swarm-worker-token \
&& sudo docker swarm join-token manager | sudo tee /etc/docker/swarm-manager-token



#Discover listening manager
#sudo yum -y install netcat

