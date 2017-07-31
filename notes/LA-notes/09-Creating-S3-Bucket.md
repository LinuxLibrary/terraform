# Creating S3 Bucket

- Create a `domain_name` variable in `variables.tf`

```
variable "domain_name" {}
```

- Declare variable for the `domain_name` in `terraform.tfvars`

```
domain_name = "linuxlibrary"
```

- Create IAM plicy and role for S3

```
# IAM Policy for S3
resource "aws_iam_instance_profile" "s3_access" {
	name = "s3_access"
	roles = ["${aws_iam_role.s3_access.name}"]
}

resource "aws_iam_role_policy" "s3_access_policy" {
	name = "s3_access_policy"
	role = "${aws_iam_role.s3_access.id}"
	policy = <<EOF
{
  "Version": "2017-07-31",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# IAM Role for S3
resource "aws_iam_role" "s3_access" {
	name = "s3_access"
	assume_role_policy = <<EOF
{
  "Version": "2017-07-31",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
```

- Create a S3 VPC

```
# S3 VPC Endpoint
resource "aws_vpc_endpoint" "private-s3" {
        vpc_id = "${aws_vpc.vpc.id}"
        service_name = "com.amazonaws.${var.aws_region}.s3"
        route_table_ids = ["${aws_vpc.vpc.main_route_table_id}", "${aws_route_table.public.id}"]
        policy = <<EOF
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
EOF
}
```

- Create S3 Bucket

```
# Create S3 Bucket
resource "aws_s3_bucket" "code" {
        bucket = "${var.domain_name}_lldev01_code"
        acl = "private"
        force_destroy = true
        tags {
                Name = "lldev01_code"
        }
}
```
