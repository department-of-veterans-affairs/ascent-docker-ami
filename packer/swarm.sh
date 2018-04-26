#!/bin/bash

###########################################################
# Environment variables needed
# NODE_TYPE -- Worker | Manager
###########################################################

#set -x

SWARM_NAME=$1
NODE_TYPE=$2
PATH=$PATH:/usr/local/bin

#check if already in swarm (server restart)
docker info | grep -w "Swarm: active" && exit 0
MGR_IP=""

if [[ "$NODE_TYPE" == "Worker" ]]
then
	while [ -z "$MGR_IP" ]
	do
		MGR_IP=`dig +short @localhost -p 8600 manager.$SWARM_NAME.service.consul | head -1`
		sleep 1
	done
	
	docker swarm join --token `consul kv get docker/swarm/$SWARM_NAME/worker` $MGR_IP:2377

elif [[ "$NODE_TYPE" == "Manager" ]]
then
	X=$RANDOM
	let "X %= 30"
	sleep $X

	MGR_IP=`dig +short @localhost -p 8600 manager.$SWARM_NAME.service.consul | head -1`
	if [ -n "$MGR_IP" ]
	then
		echo "Contacting $MGR_IP:2377 to join swarm..."
		JOIN_TOKEN=`consul kv get docker/swarm/$SWARM_NAME/manager`
		docker swarm join --token $JOIN_TOKEN $MGR_IP:2377
	else
		echo "Initializing new swarm: $SWARM_NAME"
		docker swarm init
		consul kv put docker/swarm/$SWARM_NAME/manager `docker swarm join-token -q manager`
		consul kv put docker/swarm/$SWARM_NAME/worker `docker swarm join-token -q worker`
	fi
fi	
