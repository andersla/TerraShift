#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

sudo yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
sudo yum -y update

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

sudo yum -y install docker-1.12.6
sudo systemctl enable docker
sudo systemctl start docker

sudo yum -y install NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
