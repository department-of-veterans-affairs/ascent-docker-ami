#!/bin/bash

set -x

X=$RANDOM
let "X %= 10"
sleep $X

# NODE_TYPE= Worker | Manager
NODE_TYPE=XX_NODE_TYPE
echo $NODE_TYPE

#check if already in swarm
docker info | grep -w "Swarm: active" && exit 0

# Get network number
eval `ipcalc -n \`ifconfig -a eth0 | grep inet | grep -v inet6 | awk '{print $2}'\` \`ifconfig -a eth0 | grep inet | grep -v inet6 | awk '{print $4}'\``

# Get mask in cidr format

eval `ipcalc -p \`ifconfig -a eth0 | grep inet | grep -v inet6 | awk '{print $2}'\` \`ifconfig -a eth0 | grep inet | grep -v inet6 | awk '{print $4}'\``

echo $NETWORK $PREFIX

export NETWORK
export PREFIX

nmap -n -p 2375 --open -oG /tmp/discovery.txt $NETWORK/$PREFIX >/dev/null

for i in `grep 2375 /tmp/discovery.txt | awk '{print $2}'`
        do
        #echo $i
        MGR_TOKEN=`curl -s $i:2375/swarm | tr ',' '\n'| grep SWMTKN | grep ${NODE_TYPE} | head -1 | sed -e 's/\}//g' -e 's/\"//g' | awk -F\: '{print $NF}'`
        [[ -n "$MGR_TOKEN" ]] && docker swarm join --token ${MGR_TOKEN} $i:2377 && break
        done


#try to initialize in case no manager found
[[ "$NODE_TYPE" == "Manager" ]] && docker swarm init

[[ "$NODE_TYPE" == "Manager" ]] && docker node update --availability drain `docker node ls | grep \* | awk '{print $1}'`

exit 0
