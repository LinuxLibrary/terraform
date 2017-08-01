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
  "Version": "2012-10-17",
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
  "Version": "2012-10-17",
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

# Create S3 Bucket
resource "aws_s3_bucket" "code" {
	bucket = "${var.domain_name}-lldev01-code"
	acl = "private"
	force_destroy = true
	tags {
		Name = "lldev01_code"
	}
}
