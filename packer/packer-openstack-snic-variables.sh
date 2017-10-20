#!/bin/bash

# Set packer build vars
export IMAGE_NAME="orn-os-02"
export SSH_USERNAME="centos"
export OS_SOURCE_IMAGE_NAME="CentOS 7 - latest"
export OS_FLAVOR="ssc.small"
export OS_NETWORK="3fd902bb-1d62-4b9a-bba7-4442d7c07cb3"
export OS_POOL_NAME="Public External IPv4 Network"
export OS_EXTERNAL_NET_UUID="52b76a82-5f02-4a3e-9836-57536ef1cb63"

# Set OS credentials
export OS_USERNAME="your-username" # to be changed
export OS_AUTH_URL="https://hpc2n.cloud.snic.se:5000/v3"
export OS_USER_DOMAIN_NAME="snic"
export OS_DOMAIN_NAME="snic" # same as user domain name usually
export OS_REGION_NAME="HPC2N"
export OS_PROJECT_ID=0d52d53fb6da4a3c98ed0d84fbd17a42
export OS_TENANT_ID=0d52d53fb6da4a3c98ed0d84fbd17a42 # same as project id usually
export OS_AUTH_VERSION=3
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3

unset OS_DOMAIN_ID
unset OS_TENANT_NAME

export OS_INTERFACE=public

# With Keystone you pass the keystone password.
echo "Please enter your OpenStack Password for project $OS_PROJECT_NAME as user $OS_USERNAME: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT


