#!/bin/bash

###########################################################
# Environment variables needed
# CONSUL_URL -- protocol://host:port combination to reach consul on
# NODE_TYPE -- Worker | Manager
###########################################################

set -x

INT_NAME=eth0

MY_IP=`ip -o -4 addr show $INT_NAME | awk '{print $4}' | awk -F\/ '{print $1}'`

#check if already in swarm (server restart)
docker info | grep -w "Swarm: active" && exit 0

if [[ "$NODE_TYPE" == "Worker" ]]
then
	until $(curl -sf $CONSUL_URL/docker/worker-tokens?recurse=true);
	do
		echo "waiting for worker token to appear"
	done
	
	curl -sf $CONSUL_URL/v1/kv/docker/worker-tokens?recurse=true > /tmp/worker-tokens.json
	declare -a MANAGERS=(`jq -r '.[] | {Key} | .Key' /tmp/worker-tokens.json`)
	declare -a TOKENS=(`jq -r '.[] | {Vaule} | .Value' /tmp/worker-tokens.json`)
	COUNT=`jq -r 'length' /tmp/worker-tokens.json`
	let COUNT=$COUNT-1
	let X=0
	while [ $X -le $COUNT ] 
	do
		docker swarm join --token=${TOKENS[$X]} ${MANAGERS[$X]} && exit 0
		let $X=$X+1
	done
	exit 0

elif [[ "$NODE_TYPE" == "Manager" ]]
then
	Y=$RANDOM
        let "Y %= 10"
	sleep $Y
	curl -sf $CONSUL_URL/docker/manager-tokens?recurse=true > /tmp/manager-tokens.json
	if [ -s "/tmp/manager-tokens.json" ]
	then
		#join as manager
		declare -a MANAGERS=(`jq -r '.[] | {Key} | .Key' /tmp/worker-tokens.json`)
        	declare -a TOKENS=(`jq -r '.[] | {Vaule} | .Value' /tmp/worker-tokens.json`)
        	COUNT=`jq -r 'length' /tmp/worker-tokens.json`
        	let COUNT=$COUNT-1
        	let X=0
        	while [ $X -le $COUNT ]
        	do
                	docker swarm join --token=${TOKENS[$X]} ${MANAGERS[$X]}
                	let $X=$X+1
        	done
	

	else
		#initialize swarm
		docker swarm init
	fi
	# Store join tokens and drain 
	curl -X PUT -d @- $CONSUL_URL/docker/manager-tokens/"${MY_IP}" <<< `docker swarm join-token manager`
        curl -X PUT -d @- $CONSUL_URL/docker/worker-tokens/"${MY_IP}" <<< `docker swarm join-token worker`
        docker node update --availability drain `docker node ls | grep \* | awk '{print $1}'`
	exit 0
fi	
