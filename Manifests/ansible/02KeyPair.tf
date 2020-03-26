resource "aws_key_pair" "instance" {
	key_name = "${var.instance_key_name}"
	public_key = "${file(var.instance_key_path)}"
}