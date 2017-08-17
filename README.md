# ascent-docker-ami
Packer script to create docker rhel 7 AMI on AWS using lvm storage and production settings as described by https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
Currently discovers managers running in same subnet

## To run
Create JSON settings file containing AWS ID, key and Docker EE store url:
```
    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "base_ami_id": "<id of the base rhel7 AMI",
    "image_type": "<Managaer | Worker>",
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
- investigate cluster discovery alternatives, Consul?
- move all docker version settings to user defined variables?
