# Terraform Introduction

- Terraform is an Infrastructure management tool
- By using Terraform we can maintain the Infrastructure as Code (IAC)
- Below are some of the features of Terraform
- Idempotency: Because of it we can run it as many times as we need even it won't break the running things
	- Let us assume we have an infrastructure of some EC2 instances, RDS Instances and S3 buckets
	- Something went terribly wrong and the S3 buckets were removed mistakenly
	- In such case we can run terraform with our existing template which we used to create the above environment
	- Terraform will restore the S3 buckets with all the configs we've specified without interrupting the running EC2/RDS instances
- Immutability: We don't fix the parts but we just replace those
- Scalability
