# Create Docker Master Instances
resource "aws_instance" "docker" {
        count = "${var.docker_count}"

        tags = {
                Name = "docker_${count.index}"
        }

        ami = "${var.ami}"
        instance_type = "${var.instance_type}"
        key_name = "${aws_key_pair.docker.key_name}"
        vpc_security_group_ids = ["${aws_security_group.public.id}"]
        subnet_id = "${aws_subnet.public.id}"

    	provisioner "local-exec" {
    		command = "sleep 6m"
    	}

 #       provisioner "local-exec" {
 #       	command = "sleep 6m && sudo apt-get update -y && sudo wget -qO- https://get.docker.com/ | sudo sh"
 #       }

}

resource "null_resource" "ssh_config" {
	provisioner "file" {
		source = "${file(var.mykey_path)}"
		destination = "/home/ubuntu/.ssh/authorized_keys_new"
#		depends_on = ["aws_instance.docker.local-exec"]
	}

    provisioner "local-exec" {
    	command = "cat /home/ubuntu/.ssh/authorized_keys_new >> /home/ubuntu/.ssh/authorized_keys"
#    	depends_on = ["aws_instance.docker.local-exec"]
    }

    provisioner "local-exec" {
   		command = "echo -e \"RSAAuthentication yes\nAuthorizedKeysFile    /etc/ssh/%u/authorized_keys\" >> /etc/ssh/sshd_config && service sshd reload"
#   		depends_on = ["aws_instance.docker.local-exec"]
    }

    depends_on = ["aws_instance.docker"]	
}



output "instance_public_ips" {
	value = ["aws_instance.docker.*.public_ip"]
}