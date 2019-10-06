# Create Docker Master Instances
resource "aws_instance" "docker" {
    count = "${var.docker_count}"

    tags = {
        Name = "docker_${count.index}"
    }

    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.geekhost.key_name}"
    vpc_security_group_ids = ["${aws_security_group.public.id}"]
    subnet_id = "${aws_subnet.public.id}"
#    user_data = "${file(var.geekhost_path)}"

#	provisioner "remote-exec" {
#		connection {
#			user = "ubuntu"
#			host = "${element(aws_instance.docker.*.public_ip, 0)}"
#			private_key = "${file("${var.keypath}/${var.docker_key_name}")}"
#		}
#
#		inline = [
#			"sudo curl http://169.254.169.254/latest/user-data >> /home/ubuntu/.ssh/authorized_keys"
#		]
#	}
}

output "instance_public_ips" {
	value = ["${aws_instance.docker.*.public_ip}"]
}