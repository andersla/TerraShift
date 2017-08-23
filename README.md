
# TerraShift
OpenShift Origin deployment automation with Terraform

```
# This Packer step is not needed if you are happy with the openshift
# image that is already created and on amazon servers (region eu-west-1) with the name: anders-os-02
cd packer
packer build -var-file="packer-conf-aws.json" build-aws.json

# Terraform will create an ansible inventory file from the template `inventory-openshift-template`
# terraform will insert master and node hostname and ipnumbers within the tag ${masters}, ${nodes}
# If you want to add more parameters to inventory, please do so in file: `inventory-openshift-template`

# in repo root directory:

# create a terraform config file from template
cp terraform-aws.tfvars-template terraform-aws.tfvars

# edit parameters in your config file: terraform-aws.tfvars

# create cluster
terraform get aws
terraform apply --var-file="terraform-aws.tfvars" aws

# deploy ansible playbooks
#
# OBS please note that it might take up to 20 sek for openssh to start on nodes (from terraform finish)
#
ssh-add "/path to your/private/ssh-key/of/which/uploaded/to-nodes (in terraform-aws.tfvars)
ansible-playbook openshift-ansible/playbooks/byo/config.yml

# access web console
https://<master-ip>:8443

# To destroy cluster:
terraform destroy --var-file="terraform-aws.tfvars" aws
```


