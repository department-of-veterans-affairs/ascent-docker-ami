#!/bin/bash

sudo yum -y install wget unzip deltarpm nmap curl bind-utils
sudo wget -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod 755 /usr/bin/jq


exit 0
