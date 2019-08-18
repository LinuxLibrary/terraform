# Resource to get the local ip. This is needed to get access
resource "null-resource" "localip" {
	provisioner "local-exec" {
		command = "echo $(dig +short myip.opendns.com @resolver1.opendns.com)"
	}
}