#!/bin/bash -ex


[[ -z "$DOCKER_SWARM_TOKEN" ]] && echo "Initializing swarm" && sudo docker swarm init | sudo tee  /etc/docker/swarm-worker-token \
&& sudo docker swarm join-token manager | sudo tee /etc/docker/swarm-manager-token && exit 0


# Set swarm join at startup when instance is in security group that is able to reach existing master
[[ -n "$DOCKER_SWARM_TOKEN" ]] && [[ -n "$DOCKER_SWARM_MASTER" ]] && \
sudo sed -i '/ExecStart=\/usr\/bin\/dockerd/ a ExecStartPost=-/usr/bin/docker swarm join --token '${DOCKER_SWARM_TOKEN}' '${DOCKER_SWARM_MASTER}'' \
/usr/lib/systemd/system/docker.service && sudo systemctl daemon-reload && exit 0

#sudo docker swarm join  --token ${DOCKER_SWARM_TOKEN} ${DOCKER_SWARM_MASTER} && exit 0

exit 1
