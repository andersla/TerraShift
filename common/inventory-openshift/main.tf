variable master_hostnames {
  type = "list"
}

variable master_public_ip {
  type = "list"
}

variable master_private_ip {
  type = "list"
}

variable edge_hostnames {
  type = "list"
}

variable edge_public_ip {
  type = "list"
}

variable node_hostnames {
  type = "list"
}

variable node_public_ip {
  type = "list"
}

variable node_private_ip {
  type = "list"
}

variable master_as_edge {}
variable edge_count {}
variable node_count {}
variable glusternode_count {}
variable extra_disk_device {}
variable use_cloudflare {}
variable cluster_prefix {}
variable cloudflare_domain {}

variable inventory_template_file {
  default = "inventory-openshift-template"
}

variable inventory_output_file {
  default = "inventory-openshift"
}

variable ansible_ssh_user {
  default = "centos"
}

## Generates a list of hostnames (azurerm_virtual_machine does not output them)
#data "null_data_source" "node_hostnames" {
#
#  inputs = {
#    hostname = "${split(",", join(",",var.node_private_ip ) ) }"
#  }
#}

# Generate inventory from template file
data "template_file" "inventory" {

  template = "${file("${path.root}/../${ var.inventory_template_file }")}"

  vars {
    masters                 = "${join("\n",formatlist("host-%s.openstacklocal openshift_public_ip=%s", split(",", replace( join(",",var.master_private_ip ), ".","-" )) , var.master_public_ip))}"
    nodes                   = "${join("\n",formatlist("host-%s.openstacklocal openshift_node_labels=\"{'region': 'infra','zone': 'default'}\" openshift_schedulable=true", split(",", replace( join(",",var.node_private_ip ), ".","-" )) ))}"
    ansible_ssh_user        = "${var.ansible_ssh_user}"
    master-hostname-private = "master_hostnames_private"
    master-hostname-public  = "master_hostnames_public"
    test-non-existing       = "master_hostnames_public"
  }
}





resource "null_resource" "local" {
  
  # Trigger rewrite of inventory, uuid() generates a random string everytime it is called
  triggers {
    uuid = "${uuid()}"
  }

  triggers {
    template = "${data.template_file.inventory.rendered}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > \"${path.root}/../${var.inventory_output_file}\""
  }
}


#output "hostnames" {
#  value = "${data.template_file.inventory.rendered}"
#}
