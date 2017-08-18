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
    "aws_region": "<aws region>",
    "docker_path": "https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm",
    "docker_selinux_path": "https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm"
   }
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
    - current discovery is shell based network probe, not 100%
- ~~move all docker version settings to user defined variables?~~
