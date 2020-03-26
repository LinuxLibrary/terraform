aws_region 				= "us-east-1"
aws_profile 			= "hawkeye"
keypath 				= "C:\\Users\\Arjun Shrinvas\\.ssh"
instance_key_name       = "id_rsa"
instance_key_path 		= "C:\\Users\\Arjun Shrinvas\\.ssh\\id_rsa.pub"
ansible_key_name        = "ansible"
ansible_key_path 		= "C:\\Users\\Arjun Shrinvas\\.ssh\\ansible.pub"
authorized_keys			= "C:\\Users\\Arjun Shrinvas\\.ssh\\authorized_keys"
private_key		 		= "C:\\Users\\Arjun Shrinvas\\.ssh\\id_rsa"
instance_type			= "t2.micro"
ami						= "ami-05062c82c75ed4335"
elb_healthy_threshold	= "2"
elb_unhealthy_threshold	= "2"
elb_timeout				= "3"
elb_interval			= "30"
asg_max					= "2"
asg_min					= "1"
asg_grace				= "300"
asg_hct					= "EC2"
asg_cap					= "2"
instance_count			= "2"