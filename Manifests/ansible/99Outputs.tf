output "acs_public_ip" {
	value = "${aws_instance.acs.public_ip}"
}

output "ansible_nodes_public_ips" {
	value = "${aws_instance.ansible_nodes.*.public_ip}"
}