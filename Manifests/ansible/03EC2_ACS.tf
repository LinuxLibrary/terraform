# Create Ansible Control Server

resource "aws_instance" "acs" {
  tags = {
    Name = "acs"
  }

  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.instance.key_name}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id              = "${aws_subnet.public.id}"

  connection {
    user        = "ubuntu"
    host        = "${aws_instance.acs.public_ip}"
    private_key = "${file("${var.keypath}\\${var.instance_key_name}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo useradd ansible",
      "sudo mkdir -p /home/ansible/ && sudo chmod -R 777 /home/ansible/",
    ]
  }

  provisioner "file" {
    source      = "${var.authorized_keys}"
    destination = "/home/ansible/"
  }

  provisioner "file" {
    source      = "${var.keypath}\\${var.instance_key_name}"
    destination = "/home/ubuntu/.ssh/${var.instance_key_name}"
  }

  provisioner "file" {
    source      = "${var.instance_key_path}"
    destination = "/home/ubuntu/.ssh/${var.instance_key_name}.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown -R ansible:ansible /home/ansible",
      "sudo chmod -R 0755 /home/ansible/",
      "sudo chmod 0600 /home/ubuntu/.ssh/*",
      "sudo chmod 0600 /home/ansible/.ssh/*",
      "sudo apt-get update",
      "sudo apt-get install ansible -y",
    ]
  }
}
