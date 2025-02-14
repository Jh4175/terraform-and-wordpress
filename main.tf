# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "<YOUR-KEY-NAME>"   # SSH key pair name for EC2 instance access
}

data "aws_security_group" "allow_http" {
  filter {
    name   = "group-name"
    values = ["allow_http"]
  }
}

terraform{
  backend "s3" {
    bucket       = "hjybucket"
    key          = "terraform.tfstate"
    region       = "us-east-1"
  }
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "JY_AWS_Key"          # Specify the SSH key pair name
   user_data     = file("wp_install.sh")
  
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }                  
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow_http.id]
}


