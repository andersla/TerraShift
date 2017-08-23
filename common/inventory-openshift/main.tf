variable master_hostnames {
  type = "list"
}

variable master_public_ip {
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

variable master_as_edge {}
variable edge_count {}
variable node_count {}
variable glusternode_count {}
variable extra_disk_device {}
variable use_cloudflare {}
variable cluster_prefix {}
variable cloudflare_domain {}

variable inventory_template_file { default="inventory-openshift-template" }
variable inventory_output_file { default="inventory-openshift" }
variable ansible_ssh_user { default="centos" }


# Generate inventory from template file
data "template_file" "inventory" {
  template = "${file("${path.root}/../${ var.inventory_template_file }")}"

  vars {
    masters          = "${join("\n",formatlist("%s ansible_ssh_host=%s ansible_ssh_user=centos", var.master_hostnames, var.master_public_ip))}"
    etcds            = "${join("\n",formatlist("%s ansible_ssh_host=%s ansible_ssh_user=centos", var.master_hostnames, var.master_public_ip))}"
    nodes            = "${join("\n",formatlist("%s ansible_ssh_host=%s ansible_ssh_user=centos openshift_schedulable=true", var.node_hostnames, var.node_public_ip))}"
    ansible_ssh_user = "${var.ansible_ssh_user}"
  }
}

resource "null_resource" "local" {
  triggers {
    template = "${data.template_file.inventory.rendered}"
  }

  provisioner "local-exec" {
    command = "echo \"${data.template_file.inventory.rendered}\" > ${path.root}/../${var.inventory_output_file}"
  }
}
