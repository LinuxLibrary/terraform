#################
### VARIABLES ###
#################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
	default = "LinuxLibraryKeys"
}

variable "network_address_space" {
	default = "10.0.0.0/16"
}
variable "subnet1_address_space" {
	default = "10.0.1.0/24"
}
variable "subnet2_address_space" {
	default = "10.0.2.0/24"
}

#################
### PROVIDERS ###
#################

provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "us-east-1"
}

############
### DATA ###
############

data "aws_availability_zones" "available" {}

#################
### RESOURCES ###
#################

# NETWORKING #

resource "aws_vpc" "vpc" {
	cidr_block = "${var.network_address_space}"
	enable_dns_hostnames "true"
}

resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_subnet" "subnet1" {
	cidr_block = "${var.subnet1_address_space}"
	vpc_id = "${aws_vpc.vpc.id}"
	map_public_ip_on_launch "true"
	availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "subnet2" {
	cidr_block = "${var.subnet2_address_space}"
	vpc_id = "${aws_vpc.vpc.id}"
	map_public_ip_on_launch "true"
	availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

# ROUTING #

resource "aws_route_table" "rtb" {
	vpc_id = "${aws_vpc.vpc.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.igw.id}"
	}
}

resource "aws_route_table_association" "rta_subnet1" {
	subnet_id = "${aws_subnet.subnet1.id}"
	route_table_id = "${aws_route_table.rtb.id}"
}

resource "aws_route_table_association" "rta_subnet2" {
	subnet_id = "${aws_subnet.subnet2.id}"
	route_table_id = "${aws_route_table.rtb.id}"
}

# SECURITY GROUPS #
# Nginx Security Group

resource "aws_security_group" "nginx-sg" {
	name = "nginx_sg"
	vpc_id = "${aws_vpc.vpc.id}"

	# SSH access from anywhere
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# HTTP access from anywhere
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# OutBound internet access

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

# INSTANCES #
resource "aws_instance" "nginx1" {
	ami = "ami-c58c1dd3"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.subnet1.id}"
	vpc_security_group_ids = ["${aws_security_group.nginx-sg.id}"]
	key_name = "${var.key_name}"

	connection {
		user = "ec2-user"
		private_key = "${file(private_key_path)}"
	}

	privisioner "remote-exec" {
		inline = [
			"sudo yum install nginx -y"
			"echo 'Hello Blue Team' > /var/www/html/index.html"
			"sudo service nginx start"
		]
	}
}

##############
### OUTPUT ###
##############

output "aws_instance_public_dns" {
	value = "${aws_instance.nginx1.public_dns}"
}