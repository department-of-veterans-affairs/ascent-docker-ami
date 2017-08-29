# ascent-docker-ami
Packer script to create docker rhel 7 AMI on AWS using lvm storage and production settings as described by https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
This install only sets up the software and ssh access to the docker user.  It does not create or join a swarm.  

## To run
Create JSON settings file containing AWS ID, key and Docker package urls, this example uses CE:
```

    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "aws_region": "us-east-1",
    "image_type": "<Manager|Worker>",
    "docker_selinux_path": "https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm",
    "docker_path": "https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm",
    "vault_token": "<token for accessing vault>",
    "vault_url": "<vault API url>"
    }
```
packer build -var-file=./your-settings-file docker.json
