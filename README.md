
# TerraShift
OpenShift Origin deployment automation with Terraform

```
cd packer
packer build -var-file="packer-conf-aws.json" build-aws.json

cd ..
terraform get aws
terraform apply --var-file="terraform-aws.tfvars" aws
# terraform destroy --var-file="terraform-aws.tfvars" aws

# copy inventory template
cp openshift-ansible/inventory/byo/hosts.origin.example inventory-openshift

# Edit following in inventory-openshift
ansible_ssh_user=centos
ansible_become=yes
openshift_release=v3.6.0
[masters]
ip-10-0-153-245 ansible_ssh_host=54.154.37.195 ansible_ssh_user=centos
[etcd]
[lb]
[nodes]
ip-10-0-153-245 ansible_ssh_host=54.154.37.195 ansible_ssh_user=centos
# also maybe add following:
openshift_disable_check=disk_availability,docker_storage,memory_availability

ssh-add ~/phenomenal/ssh/cloud.key
ansible-playbook openshift-ansible/playbooks/byo/config.yml
```


