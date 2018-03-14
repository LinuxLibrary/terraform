# Terraform Components

- The 2 main components for using terraform are 
	- Terraform Executable
		- To install Terraform, find the appropriate package for your system and download it. Terraform is packaged as a zip archive.
		- After downloading Terraform, unzip the package. Terraform runs as a single binary named terraform. Any other files in the package can be safely removed and Terraform will still function.
	- Terraform Configuration File (Manifest File)
		- When invoking any command that loads the Terraform configuration, Terraform loads all configuration files within the directory specified in alphabetical order.
		- The files loaded must end in either .tf or .tf.json to specify the format that is in use. Otherwise, the files are ignored. Multiple file formats can be present in the same directory; it is okay to have one Terraform configuration file be Terraform syntax and another be JSON.
		- Override files are the exception, as they're loaded after all non-override files, in alphabetical order.
		- The configuration within the loaded files are appended to each other. This is in contrast to being merged. This means that two resources with the same name are not merged, and will instead cause a validation error. This is in contrast to overrides, which do merge.
		- The order of variables, resources, etc. defined within the configuration doesn't matter. Terraform configurations are declarative, so references to other resources and variables do not depend on the order they're defined.


- We can maintain the manifest in a single file. But for simplicity of use we can split the single manifest file into multiple. Those can be re-used as per our requirement.

- Variables
- Providers
- Resources