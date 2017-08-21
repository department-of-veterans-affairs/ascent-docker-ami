# ascent-docker-ami
Packer script to create docker rhel 7 AMI on AWS using lvm storage and production settings as described by https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
This install only sets up the software and does not create or join a swarm.  

## To run
Create JSON settings file containing AWS ID, key and Docker package urls, this example uses CE:
```
    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "docker_store_url": "https://<your docker store url as provided via your docker subscription>"
    "aws_region": "us-east-1",
    "image_type": "<Manager|Worker>",
    "docker_selinux_path": "https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm",
    "docker_path": "https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm"
    }
```
packer build -var-file=./your-settings-file docker-master.json
