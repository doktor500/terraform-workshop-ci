#!/bin/bash

# volume setup
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk | grep "$DEVICENAME" | wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi
mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins

# install packages
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
apt-get update
apt-get install -y unzip default-jdk docker.io jenkins=${JENKINS_VERSION}

# install terraform
cd /usr/local/bin
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# create the docker credentials file
mkdir /var/lib/jenkins/.docker
echo 'export DOCKER_USER="${DOCKER_USER}"' >> /var/lib/jenkins/.docker/credentials
echo 'export DOCKER_PASSWORD="${DOCKER_PASSWORD}"' >> /var/lib/jenkins/.docker/credentials
chown jenkins /var/lib/jenkins/.docker/
chmod +x /var/lib/jenkins/.docker/credentials

# create the aws credentials file
mkdir /var/lib/jenkins/.aws
echo '[default]' >> /var/lib/jenkins/.aws/credentials
echo 'aws_access_key_id = ${AWS_ACCESS_KEY}' >> /var/lib/jenkins/.aws/credentials
echo 'aws_secret_access_key = ${AWS_SECRET_KEY}' >> /var/lib/jenkins/.aws/credentials

# generate ssh key
mkdir /var/lib/jenkins/.ssh
ssh-keygen -t rsa -N "" -f /var/lib/jenkins/.ssh/id_rsa
chown jenkins /var/lib/jenkins/.ssh/id_rsa*

# add jenkins user to docker group
usermod -aG docker jenkins

# restart services
systemctl daemon-reload
systemctl restart docker
service jenkins restart
