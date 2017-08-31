# Creating KeyPair

- Add a resource for keypair `keypair.tf`

```
resource "aws_key_pair" "auth" {
        key_name        = "${var.key_name}"
        public_key      = "${file(var.public_key_path)}"
}
```

- Add variables in `variables.tf`

```
variable "key_name" {}
variable "public_key_path" {}
```

- Declare the variables in `terraform.tfvars`

```
key_name	= "lldev01"
public_key_path	= "/root/.ssh/lldev01.pub"
```
