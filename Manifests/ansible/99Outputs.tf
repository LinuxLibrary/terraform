output "acs_public_ip" {
	value = "${aws_instance.acs.public_ip}"
}