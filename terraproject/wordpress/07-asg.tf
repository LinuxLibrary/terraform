# Creating Amazon Machine Image (AMI) from the Dev Instance
resource "random_id" "ami" {
	byte_length = 8
}

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

# Creating Launch Config
resource "aws_launch_configuration" "lc" {
	name_prefix = "lc-"
	image_id = "${aws_ami_from_instance.golden.id}"
	instance_type = "${var.lc_instance_type}"
	security_groups = ["${aws_security_group.private.id}"]
	iam_instance_profile = "${aws_iam_instance_profile.s3_access.id}"
	key_name = "${aws_key_pair.auth.id}"
	user_data = "${file("userdata")}"
	lifecycle {
		create_before_destroy = true
		
	}
}

# Creating Auto Scaling Group (ASG)

resource "random_id" "asg" {
	byte_length = 8
}

resource "aws_autoscaling_group" "asg" {
	availability_zones = ["${var.aws_region}b", "${var.aws_region}c"]
	name = "asg-${random_id.asg.b64}"
#	name = "asg-${aws_launch_configuration.lc.id}"
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
