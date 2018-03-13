# Creating Elastic Load Balancer (ELB)

- Create a resource for ELB

```
resource "aws_elb" "prod" {
	name = "${var.domain_name}-prod-elb"
	subnets = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
	security_groups = ["${aws_security_group.public.id}"]
	listener {
		instance_port = 80
		instance_protocol = "http"
		lb_port = 80
		lb_protocol = "http"
	}
	health_check {
		healthy_threshold = "${var.elb_healthy_threshold}"
		unhealthy_threshold = "${var.elb_unhealthy_threshold}"
		timeout = "${var.elb_timeout}"
		target = "HTTP:80/"
		interval = "${var.elb_interval}"
	}
	cross_zone_load_balancing = true
	idle_timeout = 400
	connection_draining = true
	connection_draining_timeout = 400
	tags {
		Name = "${var.domain_name}-prod-elb"
	}
}
```

- Add the variables to the `variables.tf` file

```
variable "elb_healthy_threshold" {}
variable "elb_unhealthy_threshold" {}
variable "elb_timeout" {}
variable "elb_interval" {}
```

- Declare the variables in `terraform.tfvars`

```
elb_healthy_threshold   = "2"
elb_unhealthy_threshold = "2"
elb_timeout             = "3"
elb_interval            = "30"
```
