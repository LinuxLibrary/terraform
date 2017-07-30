# Creating VPC - 02

- Subnet associations with the Public Route Table
	- Associate the public subnet

	```
	resource "aws_route_table_association" "public_assoc" {
		subnet_id = "${aws_subnet.public.id}"
		route_id = "${aws_route_table.public.id}"
	}
	```

	- Associate the private subnet 1

	```
	resource "aws_route_table_association" "private1_assoc" {
		subnet_id = "${aws_subnet.private1.id}"
		route_id = "${aws_route_table.public.id}"
	}
	```

	- Associate the private subnet 2

	```
	resource "aws_route_table_association" "private2_assoc" {
		subnet_id = "${aws_subnet.private2.id}"
		route_id = "${aws_route_table.public.id}"
	}
	```

	- Associate RDS Subnets

	```
	resource "aws_db_subnet_group" "rds_subnet_group" {
		name = "rds_subnet_group"
		subnet_ids = ["${aws_subnet.rds1.id}", "${aws_subnet.rds2.id}", "${aws_subnet.rds3.id}"]
		tags {
			Name = "rds_sng"
		}
	}
	```

- Let us create the security groups
	- 
