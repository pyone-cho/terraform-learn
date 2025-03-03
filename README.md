# terraform-learn
Learning Terryform

##### Add provider.tf
```bash
# 1- Terraform Block and attach s3 for backend
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.89.0"
    }
  }
}

# 2 - Provider Block
provider "aws" {
  region = "ap-southeast-1"
}
```
###### Terraform command
```Bash
terraform init
```
---
##### Add instances.tf
```bash
# 1 - Data Block
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# 2 - Instance Block
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "tester"
  }
}
```
###### Terraform command
```bash
terraform paln
terraform apply -auto-approve
```
---
