
# TerraShift
OpenShift Origin deployment automation with Terraform

```
# This Packer step is not needed if you are happy with the openshift
# image that is already created and on amazon servers with the name: anders-os-02
cd packer
packer build -var-file="packer-conf-aws.json" build-aws.json

# Terraform will create an ansible inventory file from the template `inventory-openshift-template`
# terraform will insert master and node hostname and ipnumbers within the tag ${masters}, ${nodes}

# in repo root directory:

# create a terraform config file from template
cp terraform-aws.tfvars-template terraform-aws.tfvars

# edit parameters in your config file: terraform-aws.tfvars

# create cluster
terraform get aws
terraform apply --var-file="terraform-aws.tfvars" aws

# deploy ansible playbooks
ssh-add "/path to your/private/ssh-key/of/which/uploaded/to-nodes (in terraform-aws.tfvars)
ansible-playbook openshift-ansible/playbooks/byo/config.yml

# To destroy cluster:
terraform destroy --var-file="terraform-aws.tfvars" aws
```


