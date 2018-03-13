# Directory and File Setup

- Create a directory

```
# mkdir terraproject && cd $_
```

- Let us create some terraform files

```
# touch {main,variables}.tf terraform.tfvars
```

- Let us run the `main.tf`

```
provider "aws" {
	region = "${vars.aws_region}"
	profile = "${vars.aws_profile}"
}
```

- Edit the `variables.tf`

```
variable "aws_region" {}
variable "aws_profile" {}
```

- Edit the `terraform.tfvars`

```
aws_profile = "lldev01"
aws_region = "us-west-2"
```

> NOTE: You can found the above details in the config file located in `~/.aws/`

