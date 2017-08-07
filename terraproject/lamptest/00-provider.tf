# AWS PROVIDER CONFIG

provider "aws" {
#	region	= "us-west-2"
#	profile	= "lldev01"
	region	= "${var.aws_region}"
	profile	= "${var.aws_profile}"
}
