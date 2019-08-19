# Key Pair
resource "aws_key_pair" "mesos" {
	key_name	= "${var.mesos_key_name}"
	public_key	= "${file(var.mesos_key_path)}"
}

resource "aws_key_pair" "ansible" {
	key_name 	= "${var.ansible_key_name}"
	public_key	= "${file(var.ansible_key_path)}"
}