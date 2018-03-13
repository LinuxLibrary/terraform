# Creating Auto Scaling Group (ASG)

- Let us create an ausoscaling group for our environment
- For creating autoscaling group we need an AMI, LaunchConfig
- Let us create an AMI first. For this we need a unique name so let us generate a random number and then create an AMI
	- Generating a random number

	```
	resource "random_id" "ami" {
	        byte_length = 8
	}
	```
	
	- Creating AMI
	
	```
	resource "aws_ami_from_instance" "golden" {
 	       name = "ami-${random_id.ami.b64}"
 	       source_instance_id = "${aws_instance.dev.id}"
 	       provisioner "local-exec" {
 	               command = "cat <<EOF > userdata
	#!/bin/bash
	/usr/bin/aws s3 sync s3://${aws_s3_bucket.code.bucket} /var/www/html/
	/bin/touch /var/spool/cron/root
	sudo /bin/echo '*/5 * * * * aws s3 sync s3://${aws_s3_bucket.code.bucket} /var/www/html/' >> /var/spool/cron/root
	EOF"
	        }
	}
	```

- Creating Launching Config
- For creating ASG as well we need a random number to name the instance. Lets create that first

```
resource "random_id" "asg" {
        byte_length = 8
}
```

- Let us create the ASG now

```
resource "aws_autoscaling_group" "asg" {
        availability_zones = ["${var.aws_region}b", "${var.aws_region}c"]
        name = "asg-${random_id.asg.b64}"
#       name = "asg-${aws_launch_configuration.lc.id}"
        max_size = "${var.asg_max}"
        min_size = "${var.asg_min}"
        health_check_grace_period = "${var.asg_grace}"
        health_check_type = "${var.asg_hct}"
        desired_capacity = "${var.asg_cap}"
        force_delete = true
        load_balancers = ["${aws_elb.prod.id}"]
        vpc_zone_identifier = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
        launch_configuration = "${aws_launch_configuration.lc.name}"
        tag {
                key = "Name"
                value = "asg-instance"
                propagate_at_launch = true
        }
        lifecycle {
                create_before_destroy = true
        }
}
```

- Now we need to create the variables in `variables.tf`

```
variable "asg_max" {}
variable "asg_min" {}
variable "asg_grace" {}
variable "asg_hct" {}
variable "asg_cap" {}
variable "lc_instance_type" {}
```

- Declare the variables in `terraform.tfvars`

```
asg_max                 = "2"
asg_min                 = "1"
asg_grace               = "300"
asg_hct                 = "EC2"
asg_cap                 = "2"
lc_instance_type        = "t2.micro"
```

- Create an empty file for `userdata` script

```
# touch userdata
```
