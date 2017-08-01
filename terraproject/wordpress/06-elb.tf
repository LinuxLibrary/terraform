# Creating Elastic Load Balancer (ELB)
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

