# SECURITY GROUP PUBLIC (SGPL01)

resource "aws_security_group" "sgpl01" {
	name			= "SGPL01"
	description		= "Used for public and private instances for load balancer access"
	vpc_id			= "${aws_vpc.vpc.id}"

	# SSH INGRESS
	ingress {
		from_port	= 22
		to_port		= 22
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	# HTTP INGRESS
	ingress {
		from_port	= 80
		to_port		= 80
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	# HTTP EGRESS
	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	
	tags {
		Name		= "Lamp-SGPL01"
	}
}

# SECURITY GROUP PRIVATE (SGPR01)

resource "aws_security_group" "sgpr01" {
	name 			= "sgpr01"
	description		= "Used for private instances"
	vpc_id			= "${aws_vpc.vpc.id}"

	ingress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	
	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1"
		cidr_blocks	= ["0.0.0.0/0"]
	}
	
	tags {
		Name		= "Lamp-SGPR01"
	}
}

# SECURITY GROUP RDS (SGRDS)

resource "aws_security_group" "sgrds" {
	name			= "sgrds"
	description		= "Used to allow access to DB Instances"
	vpc_id			= "${aws_vpc.vpc.id}"

	# MySQL INGRESS
	ingress {
		from_port	= 3306
		to_port		= 3306
		protocol	= "tcp"
		security_groups	= ["${aws_security_group.sgpl01.id}", "${aws_security_group.sgpr01.id}"]
	}
	
	tags {
		Name		= "Lamp-SGRDS"
	}
}
