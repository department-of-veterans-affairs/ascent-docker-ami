# ascent-docker-ami
Packer script to create docker rhel 7 AMI on AWS using lvm storage and production settings as described by https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
This install sets up the docker software, and the docker swarm init / join script. 
Docker swarm discovery relies on the services of a bundled Consul agent and a pre-existing Consul cluster for it to join.      

## To run
Create JSON settings file containing AWS ID, key, region, and instance type.
```

    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "aws_region": "us-east-1",
    "image_type": "<Manager|Worker>"
    }
```
packer build -var-file=./your-settings-file -var 'image_type=Worker' docker.json

