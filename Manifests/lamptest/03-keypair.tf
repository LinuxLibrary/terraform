# AWS KEYPAIR FOR LAMPTEST STACK

resource "aws_key_pair" "key01" {
	key_name		= "${var.key_name}"
	public_key		= "${file(var.pub_key_path)}"
}
