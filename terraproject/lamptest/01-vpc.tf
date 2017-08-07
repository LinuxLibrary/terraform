# VPC MAIN CONFIG

resource "aws_vpc" "vpc" {
	cidr_block		= "10.1.0.0/16"
	tags {
		Name 		= "Lamp-VPC"
	}
}

# INTERNET GATEWAY CONFIG

resource "aws_internet_gateway" "igw01" {
	vpc_id			= "${aws_vpc.vpc.id}"
	tags {
		Name		= "Lamp-IGW"
	}
}

# PUBLIC SUBNET (Lamp-PL01)

resource "aws_subnet" "snet_pl01" {
	vpc_id			= "${aws_vpc.vpc.id}"
	cidr_block		= "10.1.1.0/24"
	availability_zone	= "${var.aws_region}a"
	map_public_ip_on_launch	= true
	tags {
		Name		= "Lamp-PL01"
	}
}

# PRIVATE SUBNET-01 (PR01)

resource "aws_subnet" "snet_pr01" {
	vpc_id			= "${aws_vpc.vpc.id}"
	cidr_block		= "10.1.2.0/24"
	availability_zone	= "${var.aws_region}b"
	map_public_ip_on_launch	= false
	tags {
		Name		= "Lamp-PR01"
	}
}

# PRIVATE SUBNET-02 (PR02)

resource "aws_subnet" "snet_pr02" {
	vpc_id			= "${aws_vpc.vpc.id}"
	cidr_block		= "10.1.3.0/24"
	availability_zone	= "${var.aws_region}c"
	map_public_ip_on_launch	= false
	tags {
		Name		= "Lamp-PR02"
	}
}

# RDS SUBNET-01 (RDS01)

resource "aws_subnet" "snet_rds01" {
	vpc_id			= "${aws_vpc.vpc.id}"
	cidr_block		= "10.1.4.0/24"
	availability_zone	= "${var.aws_region}a"
	map_public_ip_on_launch	= false
	tags {
		Name		= "Lamp-RDS01"
	}
}

# RDS SUBNET-02 (RDS02)

resource "aws_subnet" "snet_rds02" {
	vpc_id			= "${aws_vpc.vpc.id}"
	cidr_block		= "10.1.5.0/24"
	availability_zone	= "${var.aws_region}b"
	map_public_ip_on_launch	= false
	tags {
		Name		= "Lamp-RDS02"
	}
}

# RDS SUBNET-03 (RDS03)

resource "aws_subnet" "snet_rds03" {
	vpc_id			= "${aws_vpc.vpc.id}"
	cidr_block		= "10.1.6.0/24"
	availability_zone	= "${var.aws_region}c"
	map_public_ip_on_launch	= false
	tags {
		Name		= "Lamp-RDS03"
	}
}

# PUBLIC ROUTE TABLE (RTPL01)

resource "aws_route_table" "rtpl01" {
	vpc_id			= "${aws_vpc.vpc.id}"
	route {
		cidr_block	= "0.0.0.0/0"
		gateway_id	= "${aws_internet_gateway.igw01.id}"
	}
	tags {
		Name		= "Lamp-RTPL01"
	}
}

# PRIVATE ROUTE TABLE (RTPR01)

resource "aws_default_route_table" "rtpr01" {
	default_route_table_id	= "${aws_vpc.vpc.default_route_table_id}"
	tags {
		Name		= "Lamp-RTPR01"
	}
}

# PUBLIC ROUTE TABLE - PUBLIC SUBNET ASSOCIATION

resource "aws_route_table_association" "snet_pl01_assoc" {
	subnet_id		= "${aws_subnet.snet_pl01.id}"
	route_table_id		= "${aws_route_table.rtpl01.id}"
}

# PUBLIC ROUTE TABLE - PRIVATE SUBNET-01 ASSOCIATION

resource "aws_route_table_association" "snet_pr01_assoc" {
	subnet_id		= "${aws_subnet.snet_pr01.id}"
	route_table_id		= "${aws_route_table.rtpl01.id}"
}

# PUBLIC ROUTE TABLE - PRIVATE SUBNET-02 ASSOCIATION

resource "aws_route_table_association" "snet_pr02_assoc" {
	subnet_id		= "${aws_subnet.snet_pr02.id}"
	route_table_id		= "${aws_route_table.rtpl01.id}"
}

# PUBLIC ROUTE TABLE - RDS SUBNET GROUP ASSOCIATION

resource "aws_db_subnet_group" "rds_assoc" {
	name			= "rds_instance_group"
	subnet_ids		= ["${aws_subnet.snet_rds01.id}", "${aws_subnet.snet_rds02.id}", "${aws_subnet.snet_rds03.id}"]
	tags {
		Name		= "Lamp-RDS-SNet-Assoc"
	}
}
