# Create Docker Master Instances
resource "aws_instance" "docker" {
        count = "${var.master_count}"

        tags = {
                Name = "docker_${count.index}"
        }

        ami = "${var.ami}"
        instance_type = "${var.instance_type}"
        key_name = "${aws_key_pair.docker.key_name}"
        vpc_security_group_ids = ["${aws_security_group.public.id}"]
        subnet_id = "${aws_subnet.public.id}"

 #       provisioner "local-exec" {
 #       	command = "sleep 6m && sudo apt-get update -y && sudo wget -qO- https://get.docker.com/ | sudo sh"
 #       }

}
