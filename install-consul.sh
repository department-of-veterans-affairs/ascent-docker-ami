#!/bin/bash -ex

sudo mkdir -p /app/consul/data /app/consul/config
curl -s https://releases.hashicorp.com/consul/0.9.2/consul_0.9.2_linux_amd64.zip > /tmp/consul.zip
unzip /tmp/consul.zip
rm /tmp/consul.zip
sudo chown root:root consul
sudo chmod 755 consul
sudo mv consul /usr/bin/consul
sudo mv /tmp/startconsul.sh /app/consul
sudo chmod 755 /app/consul/startconsul.sh
#echo "${CONSUL_ADDRESS/=/}"
#sed -i 's,'XX_CONSUL_ADDRESS','"${CONSUL_ADDRESS/=/}"',' /tmp/consul-config.json
sudo mv /tmp/consul-config.json /app/consul/config
if [ "$IMAGE_TYPE" == "Manager" ]
then
	sudo mv /tmp/swarm-manager.json /app/consul/config
elif [ "$IMAGE_TYPE" == "Worker" ]
then 
	sudo mv /tmp/swarm-worker.json /app/consul/config
fi


# Install Consul as a Service
sudo mv /tmp/consul.service /etc/systemd/system/consul.service
sudo chown root:root /etc/systemd/system/consul.service
sudo chmod 0700 /etc/systemd/system/consul.service

# Enable Service
sudo systemctl enable consul.service



#sudo chown -R docker:docker /app/consul

