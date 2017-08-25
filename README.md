
# TerraShift
OpenShift Origin deployment automation with Terraform
These scripts are tested with Terraform version 0.92 For now not working with 0.10

** Please note that this repo contains a subrepo so to checkout please use the ´--recursive´ parameter **

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

OBS please note that it might take up to 20 sek for openssh to start on nodes (from terraform finish)

Fist add your ssh-hey:

    ssh-add "/path to your/private/ssh-key/of/which/uploaded/to-nodes (in terraform-aws.tfvars)

Then run playbook:

    ansible-playbook openshift-ansible/playbooks/byo/config.yml

Access web console:

    https://<master-ip>:8443

To destroy cluster:

    terraform destroy --var-file="terraform-aws.tfvars" aws


Testing:

If you want to use master as deployer-host then first copy inventory and ansible.cfg to host

    scp inventory-openshift ansible.cfg centos@<master-ip>:~

    # Enter master and forward ssh-agent
    ssh -A centos@<master-ip>

    # Ansible
    cd openshift-ansible
    git checkout release-3.6
    git pull
    cd ..
    ansible-playbook openshift-ansible/playbooks/byo/config.yml


