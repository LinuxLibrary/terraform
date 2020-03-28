resource "local_file" "ansible_inventory" {
	content = "[server]\n${aws_instance.acs.private_ip}\n\n[nodes]\n${join("\n",aws_instance.ansible_nodes.*.private_ip)}\nhost_key_checking=false"

	filename = "ec2NodesInv"
}

resource "null_resource" "CopyAnsibleFiles" {
	connection {
		user = "ubuntu"
		host = "${aws_instance.acs.public_ip}"
		private_key = "${file("${var.keypath}\\${var.instance_key_name}")}"
	}

	provisioner "file" {
		source = "ec2NodesInv"
		destination = "/tmp/ec2NodesInv"
	}

	provisioner "file" {
		source = "05AnsibleNodesConfig.yml"
		destination = "/tmp/05AnsibleNodesConfig.yml"
	}

	provisioner "remote-exec" {
		inline = [
			"ansible-playbook -i /tmp/ec2NodesInv /tmp/05AnsibleNodesConfig.yml",
		]
	}
}