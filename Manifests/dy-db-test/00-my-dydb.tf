# AWS PROVIDER CONFIG

provider "aws" {
	region	= "${var.aws_region}"
	profile	= "${var.aws_profile}"
}

resource "null_resource" "role" {
#Create the service role
  provisioner "local-exec" {
    command = "aws iam create-role --role-name MyIAMAutoscalingServiceRole --assume-role-policy-document file://trust-relationship.json | jq .Role.Arn | tr -d '\"'"
  }
}

resource "null_resource" "policy" {
#Create an IAM policy for the service role
  provisioner "local-exec" "arn" {
    command = "aws iam create-policy --policy-name MyIAMAutoscalingServicePolicy --policy-document file://service-role-policy.json | jq .Policy.Arn | tr -d '\"'"
  }
}

resource "null_resource" "attach_role_policy" {
  #Attach the policy to the service role:
  provisioner "local-exec" {
    command = "aws iam attach-role-policy --role-name MyIAMAutoscalingServiceRole --policy-arn ${null_resource.policy.arn}"
  }

  #create the table
  provisioner "local-exec" {
    command = "aws dynamodb create-table --table-name TestTable --attribute-definitions AttributeName=pk,AttributeType=N AttributeName=sk,AttributeType
=N --key-schema AttributeName=pk,KeyType=HASH AttributeName=sk,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5"
  }

  #get the arn of iam role
  provisioner "local-exec" {
    command = "aws iam get-role --role-name MyIAMAutoscalingServiceRole --query \"Role.Arn\""
  }

  #to register the scalable target
  provisioner "local-exec" {
    command = "aws application-autoscaling register-scalable-target --service-namespace dynamodb --resource-id 'table/TestTable' --scalable-dimension 'dynamodb:table:WriteCapacityUnits' --min-capacity 5 --max-capacity 10 --role-arn ${null_resource.role.arn}"
  }

  #to create the policy
  provisioner "local-exec" {
    command = "aws application-autoscaling put-scaling-policy --service-namespace dynamodb --resource-id 'table/TestTable' --scalable-dimension 'dynamo
db:table:WriteCapacityUnits' --policy-name 'MyScalingPolicy' --policy-type 'TargetTrackingScaling' --target-tracking-scaling-policy-configuration file:
//scaling-policy.json"
  }

}
