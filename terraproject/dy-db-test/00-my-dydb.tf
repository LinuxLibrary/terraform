# AWS PROVIDER CONFIG

provider "aws" {
	region	= "${var.aws_region}"
	profile	= "${var.aws_profile}"
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "aws iam create-role --role-name MyIAMAutoscalingServiceRole --assume-role-policy-document file://trust-relationship.json"
  }
}
