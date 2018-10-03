# Ascent Docker AMI repo
## This project contains...
- **modules** - a folder of reusable terraform modules for bringing up a functional docker cluster

- **packer** - set of packer scripts which creates an AMI provisioned specifically for a secure docker swarm


## Generating Client Certificates
Since the docker swarm has mutual TLS enabled, you'll need to generate client certificates to connect to the daemon.

```bash
# First, make sure you have the vault client installed and the
#  VAULT_ADDR environment variable set to a vault instance that
#  is in the same environment as your docker daemon before doing
#  the following...

vault write pki/issue/vetservices common_name=local.internal.vetservices.gov

# Note that you can have values other than 'local' above

# The output of the above issues a key, certificate, and CA.
# Take the key, certificate, and CA and saved them to files
#    docker.key, docker.crt, and ca.crt respectively
#    (note that you can save them to a differently named file,
#    but you'll need to be consistent)

# To authenticate to the daemon...
docker --tlsverify --tlscacert=ca.crt --tlscert=docker.crt \
      --tlskey=docker.key -H=$DOCKER_HOST:2376 \
      ${your-docker-command}

# Make sure to replace $DOCKER_HOST with the hostname or IP with which you connect to docker.
```
