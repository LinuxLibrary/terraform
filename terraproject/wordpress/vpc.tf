# VPC CIDR-Block
resource "aws_vpc" "vpc" {
	cidr_block = "10.1.0.0/16"
}

# Internet Gateway
resource "aws_internet_gateway" "igw01" {
	vpc_id = "${aws_vpc.vpc.id}"
	tags {
		Name = "igw01"
	}
}

# Route Table - PUBLIC
resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.igw01.id}"
	}
	tags {
		Name = "public"
	}
}

# Route Table - PRIVATE
resource "aws_default_route_table" "private" {
	default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
	tags {
		Name = "private"
	}
}

# Subnet - PUBLIC
resource "aws_subnet" "public" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.1.0/24"
	map_public_ip_on_launch = true
	availability_zone = "us-west-2a"
	tags {
		Name = "public"
	}
}

# Subnet - PRIVATE01
resource "aws_subnet" "private1" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.2.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-west-2b"
	tags {
		Name = "private1"
	}
}

# Subnet - PRIVATE02
resource "aws_subnet" "private2" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.3.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-west-2c"
	tags {
		Name = "private2"
	}
}

# Subnet - RDS01
resource "aws_subnet" "rds1" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.4.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-west-2a"
	tags {
		Name = "rds1"
	}
}

# Subnet - RDS02
resource "aws_subnet" "rds1" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.5.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-west-2b"
	tags {
		Name = "rds2"
	}
}

# Subnet - RDS03
resource "aws_subnet" "rds3" {
	vpc_id = "${aws_vpc.vpc.id}"
	cidr_block = "10.1.6.0/24"
	map_public_ip_on_launch = false
	availability_zone = "us-west-2c"
	tags {
		Name = "rds3"
	}
}

# Subnet association with Route Table - PUBLIC
resource "aws_route_table_association" "public_assoc" {
	subnet_id = "${aws_subnet.public.id}"
	route_id = "${aws_route_table.public.id}"
}

# Subnet association with Route Table - PRIVATE1
resource "aws_route_table_association" "private1-assoc" {
	subnet_id = "${aws_subnet.private1.id}"
	route_id = "${aws_route_table.public.id}"
}

# Subnet association with Route Table - PRIVATE2
resource "aws_route_table_association" "private2-assoc" {
	subnet_id = "${aws_subnet.private2.id}"
	route_id = "${aws_route_table.public.id}"
}

# Subnet association with Route Table - RDS_GROUP
resource "aws_route_table_association" "rds_instance_group" {
	name = "rds_instance_group"
	subnet_ids = ["${aws_subnet.rds1.id}", "${aws_subnet.rds2.id}", "${aws_subnet.rds3.id}"]
	tags {
		Name = "rds_sng"
	}
}
