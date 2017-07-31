# Creating RDS Instance

- Add a DB instance with the following parameters
	- Stogare size	: 10G
	- Engine	: MySQL
	- Version	: 5.6.27
	- Instance Class: 
	- DB Name	: 
	- Username	: 
	- Password	: 
	- DB Subnet GRP	: 
	- VPC SG GRP IDs: 

```
resource "aws_db_instance" "db" {
	allocated_storage	= 20
	engine			= "mysql"
	engine_version		= "5.6.27"
	instance_class		= "${var.db_instance_class}"
	name			= "${var.dbname}"
	username		= "${var.dbuser}"
	password		= "${var.dbpassword}"
	db_subnet_group_name	= "${aws_db_subnet_group.rds_instance_group.name}"
	vpc_security_group_ids	= ["${aws_security_group.rds.id}"]
}
```

- Lets add the variables to `variables.tf`

```
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}
```

- Let us now declare the variables in `terraform.tfvars`

```
db_instance_class	= "db.t2.micro"
dbname			= "lldev01"
dbuser			= "lldev01"
dbpassword		= "lldev01pass"
```
