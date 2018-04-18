#!/bin/bash

set -x

# base yum packages
sudo yum -y install wget unzip deltarpm nmap curl bind-utils ntp
sudo systemctl enable ntpd

# Install our Vault CA service
sudo chown root:root /tmp/vault-ca.sh /tmp/vault-ca.service
sudo mv /tmp/vault-ca.sh /root/vault-ca.sh
sudo mv /tmp/vault-ca.service /etc/systemd/system/vault-ca.service
sudo systemctl daemon-reload
sudo systemctl enable vault-ca.service