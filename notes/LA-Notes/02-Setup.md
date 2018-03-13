# Terraform Setup

- Let us create a AWS user from the IAM console
- Create an admins group and add the above user to admins group
- Install python if not installed
- Download and install `pip`

```
# curl -O http://bootstrap.pypa.io/get-pip.py
# python get-pip.py
```

- Install `awscli` through `pip`

```
# pip install awscli
```

- Configure your AWS access

```
# aws configure
(Input your ACCESS Key ID, Secret Access Key and Region)
```

- Create an SSH key

```
# ssh-keygen
```

- Add the key to the profile

```
# ssh-agent bash
# ssh-add ~/.ssh/id_rsa.pub
```

- Download terraform and unzip 

```
# wget https://releases.hashicorp.com/terraform/0.7.10/terraform_0.7.10_linux_amd64.zip
# mkdir ~/terraform
# unzip terraform_0.7.10_linux_amd64.zip -d ~/terraform
```

- Lets configure the PATH or else create a softlink for terraform

```
# export PATH=$PATH:~/terraform
	(or)
# ln -s ~/terraform/terraform /usr/sbin/terraform
```

- Install `ansible`

```
# yum install ansible -y
```

- Let us create a Route53 delegation for creating unique deligations

```
# aws route53 create-reusable-delegation-set --caller-reference 12345
```
