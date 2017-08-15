# ascent-docker-ami
Packer script to create docker rhel 7 AMI on AWS using lvm storage and production settings as described by https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/

## To run
Create JSON settings file containing AWS ID, key and Docker EE store url:
```
    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "base_ami_id": "<id of the base rhel7 AMI"
    "join_token": "<token of swarm to join, can be empty to initialize new swarm>",
    "swarm_master": "<dns/ip:port of Master ASG ELB, leave empty to initialize a new swarm",
    "docker_store_url": "https://<your docker store url as provided via your docker subscription>"
    }
```
packer build -var-file=./your-settings-file docker-master.json




## To do:
- ~~research modifying master AMI systemd startup scripts to join existing swarm if provided or create new swarm if not~~
    - ~~create worker script~~
- Volume sizing
- Determine VA license information
    - Test using CentOS packages on RHEL if license not found
- correct instance size and region before running in govCloud
- move all docker version settings to user defined variables?
