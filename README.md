# ascent-docker-ami
Packer script to create docker rhel 7 AMI on AWS using lvm storage and production settings as described by https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
This install sets up the docker software, docker swarm init / join script, and ssh access to the docker user. 
Docker swarm discovery relies on the services of a bundled Consul agent and a pre-existing Consul cluster for it to join.      

## To run
Create JSON settings file containing AWS ID, key, instance type, and Vault details (for ssh machine access integration).
```

    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "aws_region": "us-east-1",
    "image_type": "<Manager|Worker>",
    "consul_address": "<join address for consul agent>",
    "vault_token": "<token for accessing vault>",
    "vault_url": "<vault API url>"
    }
```
packer build -var-file=./your-settings-file docker.json

## Swarm
Most recent swarm discovery can be found in the "consul_swarm" branch
