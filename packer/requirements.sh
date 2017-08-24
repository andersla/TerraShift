#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing EPEL repository..."
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

echo "Disabling EPEL repository globally..."
sudo sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

echo "Installing deps..."
sudo yum -y install wget git net-tools
sudo yum -y install bind-utils
sudo yum -y install iptables-services
sudo yum -y install bridge-utils bash-completion
sudo yum -y install kexec-tools sos psacct
sudo yum -y install NetworkManager

echo "Installing Ansible and its deps..."
sudo yum -y --enablerepo=epel install ansible pyOpenSSL

echo "Update all"
sudo yum -y update

echo "Installing docker"
sudo yum -y install docker-1.12.6

echo "Edit the /etc/sysconfig/docker"
sudo sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16"' \
/etc/sysconfig/docker

# clone repo
cd ~
git clone https://github.com/openshift/openshift-ansible

sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "Pulling required Docker images..."

echo "None to pre-pull"
