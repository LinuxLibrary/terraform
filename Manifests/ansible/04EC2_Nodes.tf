# EC2 Instances for Ansible Nodes
resource "aws_instance" "ansible_nodes" {
	count = "${var.instance_count}"

	tags = {
		Name = "ansible_node_${count.index}"
	}

    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.instance.key_name}"
    vpc_security_group_ids = ["${aws_security_group.public.id}"]
    subnet_id = "${aws_subnet.public.id}"
}

# Provision Remote Hosts To Ansible Nodes
resource "null_resource" "ProvisionRemoteHostsToAnsibleNodes" {
	count = "${var.instance_count}"

	connection {
		user = "ubuntu"
		host = "${element(aws_instance.ansible_nodes.*.public_ip, count.index)}"
		private_key = "${file("${var.keypath}\\${var.instance_key_name}")}"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo useradd ansible && sudo echo ansible | passwd ansible",
			"sudo mkdir -p /home/ansible/ && sudo chmod -R 777 /home/ansible/",
		]
	}

	provisioner "file" {
		source = "${var.authorized_keys}"
		destination = "/home/ansible"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo chown -R ansible:ansible /home/ansible",
			"sudo chmod -R 0755 /home/ansible",
			"sudo chmod 0600 /home/ansible/.ssh/*",
		]
	}

}