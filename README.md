# ascent-docker-ami
Packer script to create docker rhel 7 AMI on AWS using lvm storage and production settings as described by https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
This install only sets up the software and ssh access to the docker user.  It does not create or join a swarm.  

## To run
Create JSON settings file containing AWS ID, key, instance type, and Vault details (for ssh machine access integratio).
```

    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "aws_region": "us-east-1",
    "image_type": "<Manager|Worker>",
    "vault_token": "<token for accessing vault>",
    "vault_url": "<vault API url>"
    }
```
packer build -var-file=./your-settings-file docker.json

## Swarm
Most recent swarm discovery can be found in the "consul_swarm" branch
