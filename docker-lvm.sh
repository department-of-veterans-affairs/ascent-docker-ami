#! /bin/bash -e

set -x

#lvm creation for docker version < 17.06 production
sudo yum -y install device-mapper-persistent-data lvm2 wget
sudo pvcreate /dev/xvdb
sudo vgcreate docker /dev/xvdb
sudo lvcreate --wipesignatures y -n thinpool docker -l 95%VG
sudo lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
sudo lvconvert -y \
--zero n \
-c 512K \
--thinpool docker/thinpool \
--poolmetadata docker/thinpoolmeta
sudo mv /tmp/docker-thinpool.profile /etc/lvm/profile/docker-thinpool.profile 
sudo chown root:root /etc/lvm/profile/docker-thinpool.profile
sudo lvchange --metadataprofile docker-thinpool docker/thinpool
sudo lvs -o+seg_monitor
sudo mkdir -p /var/lib/docker.bk
test -d /var/lib/docker && sudo mv -f /var/lib/docker/* /var/lib/docker.bk

exit 0
