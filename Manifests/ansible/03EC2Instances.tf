# Create Ansible Control Server

resource "aws_instance" "acs" {
	tags = {
		Name = "acs"
	}

	ami = "${var.ami}"
	instance_type = "${var.instance_type}"
	key_name = "${aws_key_pair.instance.key_name}"
	vpc_security_group_ids = ["${aws_security_group.public.id}"]
	subnet_id = "${aws_subnet.public.id}"

	provisioner "remote-exec" {
		connection {
			user = "ubuntu"
			host = "${aws_instance.acs.public_ip}"
			private_key = "${file("${var.keypath}\\${var.instance_key_name}")}"
		}

		inline = [
			"sudo useradd ansible && sudo echo ansible | passwd ansible",
			"sudo mkdir -p /home/ansible/.ssh/ && sudo chmod -R 777 /home/ansible/",
		]

	}

	provisioner "file" {
		source = "${var.authorized_keys}"
		destination = "/home/ansible/.ssh/authorized_keys"

		connection {
			user = "ubuntu"
			host = "${aws_instance.acs.public_ip}"
			private_key = "${file("${var.keypath}\\${var.instance_key_name}")}"
		}
	}

	provisioner "remote-exec" {
		connection {
			user = "ubuntu"
			host = "${aws_instance.acs.public_ip}"
			private_key = "${file("${var.keypath}\\${var.instance_key_name}")}"
		}

		inline = [
			"sudo chown -R ansible:ansible /home/ansible",
			"sudo chmod -R 0755 /home/ansible/ && sudo chmod -R 0700 /home/ansible/.ssh/ && sudo chmod 0600 /home/ansible/.ssh/authorized_keys",
			"sudo apt-get update",
			"sudo apt-get install python-pip -y",
			"sudo pip install ansible",
		]
	}

}