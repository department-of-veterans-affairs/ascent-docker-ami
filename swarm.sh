#!/bin/bash

###########################################################
# Environment variables needed
# NODE_TYPE -- Worker | Manager
###########################################################

#set -x

#check if already in swarm (server restart)

NODE_TYPE=XX_NODE_TYPE

docker info | grep -w "Swarm: active" && exit 0
SG=`curl -s http://169.254.169.254/latest/meta-data/security-groups`
MGR_IP=""

if [[ "$NODE_TYPE" == "Worker" ]]
then
	while [ -z "$MGR_IP" ]
	do
		MGR_IP=`dig +short @localhost -p 8600 manager.swarm-$SG.service.consul | head -1`
		sleep 1
	done
	
	docker swarm join --token `consul kv get docker/swarm/$SG/worker` $MGR_IP:2377

elif [[ "$NODE_TYPE" == "Manager" ]]
then
	X=$RANDOM
	let "X %= 30"
	sleep $X

	MGR_IP=`dig +short @localhost -p 8600 manager.swarm-$SG.service.consul | head -1`
	if [ -n "$MGR_IP" ]
	then
		docker swarm join --token `consul kv get docker/swarm/$SG/manager` $MGR_IP:2377
	else
		docker swarm init
		consul kv put docker/swarm/$SG/manager `docker swarm join-token -q manager`
		consul kv put docker/swarm/$SG/worker `docker swarm join-token -q worker`
	fi
        docker node update --availability drain `docker node ls | grep \* | awk '{print $1}'`
fi	
