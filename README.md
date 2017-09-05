
# TerraShift
OpenShift Origin deployment automation with Terraform
These scripts are tested with Terraform version 0.92 For now not working with 0.10

**Please note that this repo contains a subrepo so to checkout please use the ´--recursive´ parameter**

    git clone --recursive https://github.com/andersla/test-terrashift.git

This Packer step is not needed if you are happy with the openshift
image that is already created and on amazon servers (region `eu-west-1`) with the name: `orn-os-02`

    cd packer
    packer build -var-file="packer-conf-aws.json" build-aws.json

Terraform will create an ansible inventory file from the template `inventory-openshift-template`
terraform will insert master and node hostname and ipnumbers within the tag `${masters}`, `${nodes}`
If you want to add more parameters to inventory, please do so in file: `inventory-openshift-template`

Create a terraform config file from template

    cp terraform-aws.tfvars-template terraform-aws.tfvars

Edit parameters in your config file: `terraform-aws.tfvars`

Create cluster

    terraform get aws
    terraform apply --var-file="terraform-aws.tfvars" aws

If you not are happy with default node-labeling (e.g. want master to be schedulable or add labels to master,
then edit inventory file `intentory-openshift`

Deploy ansible playbooks:

**OBS please note that it might take up to 20 sek for openssh to start on nodes (from terraform finish)**

Fist add your ssh-hey:

    # start agent if not already started
    eval `ssh-agent -s`
    # add your privaye key to agent
    ssh-add "/path to your/private/ssh-key/of/which/uploaded/to-nodes (in terraform-aws.tfvars)"

Then run playbook:

    ansible-playbook openshift-ansible/playbooks/byo/config.yml

Access web console:

    https://<master-ip>:8443

To destroy cluster:

    terraform destroy --var-file="terraform-aws.tfvars" aws

## Commands to create and prepare a deployer node

First create and connect together vpc, subnet, security-group, route-table, internet-gateway

Then ssh to server

     ssh centos@x.x.x.x

Install:

     sudo su
     yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
     yum -y --enablerepo=epel install ansible pyOpenSSL python-cryptography python-lxml
     yum install -y unzip

     TERRAFORM_VERSION=0.9.8
     TERRAFORM_SHA256SUM=f951885f4e15deb4cf66f3b199964e3e74a0298bb46c9fe42e105df2ebcf3d16
     curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > \
         "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
         echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > \
         "terraform_${TERRAFORM_VERSION}_SHA256SUMS" && \
         sha256sum -c "terraform_${TERRAFORM_VERSION}_SHA256SUMS" && \
         unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /bin && \
         rm -f "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

     exit # (su)

     # Clone TerraShift repo
     git clone --recursive https://github.com/andersla/test-terrashift.git

     # Follow guide above to setup an OpenShift cluster

Misc. commands

     # Stop deployer instance
     aws ec2 stop-instances --region eu-west-1 --instance-ids <instance id>
     # Start deployer
     aws ec2 start-instances --region eu-west-1 --instance-ids <instance id>
     # Get deployer ip
     aws ec2 describe-instances --region eu-west-1 --instance-ids <instance id>
