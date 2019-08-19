# Create Ansible Server
resource "aws_instance" "ansible_server" {
	tags = {
		Name = "AnsibleServer"
	}

	ami = "${var.ami}"
	instance_type = "${var.instance_type}"
	key_name = "${aws_key_pair.ansible.key_name}"
	vpc_security_group_ids = ["${aws_security_group.public.id}"]
	subnet_id = "${aws_subnet.public.id}"

	provisioner "local-exec" {
		command = "sleep 6m && apt-get update -y && apt-get install python python-pip git -y && pip install ansible-y"
	}
}