# Creating Route53

- If we have a domain name then we can use this.
- At first we need to create a Primary Zone

```
resource "aws_route53_zone" "primary" {
        name = "${var.domain_name}"
        delegation_set_id = "${var.delegation_set}"
}
```

- Now we need to create the variables in `variables.tf`

```
variable "delegation_set" {}
```

- Declare the `delegation_set` variable in `terraform.tfvars` 

```
delegation_set = "XXXXXXXXXX"
```

	- You can get the `delegation_set` by the following command

	```
	# aws route53 list-reusable-delegation-sets --profile <PROFILE_NAME>
	
	Ex:
	# aws route53 list-reusable-delegation-sets --profile lldev01
	```

- Now we need to create the `www` pointer for the domain

```
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
```

- Let us create the `dev` record now

```
# Creating dev record
resource "aws_route53_record" "dev" {
        zone_id = "${aws_route53_zone.primary.zone_id}"
        name = "dev.${var.domain_name}.com"
        type = "A"
        ttl = "300"
        records = ["${aws_instance.dev.public_ip}"]
}
```

- Finally we need to create our `db` record

```
# Creating db record
resource "aws_route53_record" "db" {
        zone_id = "${aws_route53_zone.primary.zone_id}"
        name = "db.${var.domain_name}.com"
        type = "CNAME"
        ttl = "300"
        records = ["${aws_db_instance.db.address}"]
}
```
