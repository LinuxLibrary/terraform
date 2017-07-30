# Creating VPC - 01

- Create a CIDR block with /16 suffix

```
resource "aws_vpc" "vpc" {
	cidr_block = "10.1.0.0/16"
}
```

- Create Internet Gateway

```
resource "aws_internet_gateway" "internet_gateway" {
	vpc_id = "${aws_vpc.vpc.ic}"
}
```

- Create Route Tables
	- Add the public route table

	```
	resource "aws_route_table" "public" {
		vpc_id = "${aws_vpc.vpc.id}"
		route {
			cidr_block = "0.0.0.0/0"
			gateway_id = "${aws_internet_gateway.internet_gateway.id}"
		}
		tags {
			Name = "public"
		}
	}
	```

	- Add the private route table
	
	```
	resource "aws_default_route_table" "private" {
		default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
		tags {
			Name = "private"
		}
	}
	```

- Create the subnets
	- Add the public subnet

	```
	resource "aws_subnet" "public" {
		vpc_id = "${aws_vpc.vpc.id}"
		cidr_block = "10.1.1.0/24"
		map_public_ip_on_launch = true
		availability_zone = "us-west-2a"
		tags {
			Name = "public"
		}
	}
	```

	- Add the private subnet 1

	```
	resource "aws_subnet" "private1" {
		vpc_id = "${aws_vpc.vpc.id}"
		cidr_block = "10.1.2.0/24"
		map_public_ip_on_launch = false
		availability_zone = "us-west-2b"
		tags {
			Name = "private1"
		}
	}
	```

	- Add the private subnet 2

	```
	resource "aws_subnet" "private2" {
		vpc_id = "${aws_vpc.vpc.id}"
		cidr_block = "10.1.3.0/24"
		map_public_ip_on_launch = false
		availability_zone = "us-west-2c"
		tags {
			Name = "private2"
		}
	}
	```

	- Add the rds subnet 1

	```
	resource "aws_subnet" "rds1" {
		vpc_id = "${aws_vpc.vpc.id}"
		cidr_block = "10.1.4.0/24"
		map_public_ip_on_launch = false
		availability_zone = "us-west-2a"
		tags {
			Name = "rds1"
		}
	}
	```

	- Add the rds subnet 2

	```
	resource "aws_subnet" "rds2" {
		vpc_id = "${aws_vpc.vpc.id}"
		cidr_block = "10.1.5.0/24"
		map_public_ip_on_launch = false
		availability_zone = "us-west-2b"
		tags {
			Name = "rds2"
		}
	}
	```

	- Add the rds subnet 3

	```
	resource "aws_subnet" "rds3" {
		vpc_id = "${aws_vpc.vpc.id}"
		cidr_block = "10.1.6.0/24"
		map_public_ip_on_launch = false
		availability_zone = "us-west-2c"
		tags {
			Name = "rds3"
		}
	}
	```
