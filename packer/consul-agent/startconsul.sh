#!/bin/bash

SG=`curl -s http://169.254.169.254/latest/meta-data/security-groups | tr '\n' '\-'`
IP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
CONFIG_FILE=`ls /app/consul/config/swarm-*`

grep -q XX_SG $CONFIG_FILE && sed -i "s,XX_SG,$SG," $CONFIG_FILE

/usr/bin/consul agent -bind $IP -config-dir /app/consul/config

