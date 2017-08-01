# Creating Primary Zone
resource "aws_route53_zone" "primary" {
	name = "${var.domain_name}"
	delegation_set_id = "${var.delegation_set}"
}

# Creating www pointer
resource "aws_route53_record" "www" {
	zone_id = "${aws_route53_zone.primary.zone_id}"
	name = "www.${var.domain_name}.com"
	type = "A"
	alias {
		name = "${aws_elb.prod.dns_name}"
		zone_id = "${aws_elb.prod.zone_id}"
		evaluate_target_health = false
	}
}

# Creating dev record
resource "aws_route53_record" "dev" {
	zone_id = "${aws_route53_zone.primary.zone_id}"
	name = "dev.${var.domain_name}.com"
	type = "A"
	ttl = "300"
	records = ["${aws_instance.dev.public_ip}"]
}

# Creating db record
resource "aws_route53_record" "db" {
	zone_id = "${aws_route53_zone.primary.zone_id}"
	name = "db.${var.domain_name}.com"
	type = "CNAME"
	ttl = "300"
	records = ["${aws_db_instance.db.address}"]
}
