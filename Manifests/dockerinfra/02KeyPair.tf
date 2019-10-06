# Key Pair
resource "aws_key_pair" "geekhost" {
	key_name	= "${var.geekhost}"
	public_key	= "${file(var.geekhost_path)}"
}

resource "aws_key_pair" "docker" {
	key_name	= "${var.docker_key_name}"
	public_key	= "${file(var.docker_key_path)}"
}

resource "aws_key_pair" "ansible" {
	key_name 	= "${var.ansible_key_name}"
	public_key	= "${file(var.ansible_key_path)}"
}