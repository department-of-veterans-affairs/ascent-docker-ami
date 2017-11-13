#!/bin/bash

set -x

# base yum packages
sudo yum -y install wget unzip deltarpm nmap curl bind-utils ntp
sudo systemctl enable ntpd

# aws cli
curl -s "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm -rf awscli-bundle awscli-bundle.zip

# jq command line JSON parser
sudo wget -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod 755 /usr/bin/jq

# Install our Vault CA service
sudo chown root:root /tmp/vault-ca.sh /tmp/vault-ca.service
sudo mv /tmp/vault-ca.sh /root/vault-ca.sh
sudo mv /tmp/vault-ca.service /etc/systemd/system/vault-ca.service
sudo systemctl daemon-reload
sudo systemctl enable vault-ca.service