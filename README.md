# terraform-learn
Learning Terryform

##### Step 1 - Add provider.tf
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

##### Step 2 - Add instances.tf
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

##### Step 3 - Add Backend Resource and Terraform Lock
###### 3.1 Add providers.tf
```bash
# 1- Terraform Block
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
###### 3.2 Add dynamodb.tf
```bash
# 1 - Create dynamodb table for terraform lock
resource "aws_dynamodb_table" "terraform_lock" {
  name = "TerraformLock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```
###### 3.3 Add s3.tf
```bash
# 1 - Create S3 Bucket
resource "aws_s3_bucket" "backend-bucket" {
  bucket = "kpc-terraform-backend"

  tags = {
    Name        = "Terraform Backend"
    Environment = "Dev"
  }

  force_destroy = true
}

# 2 - S3 Public Access Block
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.backend-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

# 3 - S3 Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.backend-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4 - S3 Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backend-bucket.id
  
  versioning_configuration {
    status = "Disabled"
  }
}
```
###### 3.4 Modifie "main providers.tf" for backend lock
```bash
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.89.0"
    }
  }

  backend "s3" {
    bucket         = "kpc-terraform-backend"
    dynamodb_table = "TerraformLock"
    encrypt        = true
    key            = "development/terraform-learn/state"    //terraform state save path
    region         = "ap-southeast-1"
  }
}

# 2 - Provider Block
provider "aws" {
  region = "ap-southeast-1"
}
```
###### 3.5 Terraform command
```bash
cd backend
terraform init
terraform plan
terraform apply -auto-approve
terraform state list    //show terraform creation state
cd ..
terraform init
terraform plan
terraform apply -auto-approve
```
---

##### Step 4 - Add variables.tf for request instance name but default
###### 4.1 Add variables.tf 
```bash
variable "server_name" {
  type        = string
  description = "This is request server name block"
  default     = "test-server"
  validation {
    condition     = length(var.server_name) > 7 && length(var.server_name) < 20
    error_message = "Server name must be between 7 and 20 words"
  }
}
```
###### 4.2 Modify instances.tf
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
    Name = var.server_name
  }
}
```
###### 4.3 Terraform command
```bash
terraform plan
terraform apply -auto-approve
terraform state list    //show terraform creation state
```
---

##### Step 5 - Modify variables.tf and instances.tf
###### 5.1 Modify variables.tf
```bash
variable "server_name" {
  type        = string
  description = "This block is request server name"
  validation {
    condition     = length(var.server_name) > 7 && length(var.server_name) < 20
    error_message = "Server name must be between 7 and 20 words"
  }
}
variable "server_type" {
  type = string
  description = "This block is Choosing server instance type"
  validation {
    condition = contains(["t2.micro", "t3a.micro"], var.server_type)
    error_message = "Must be either t2.micro or t3.micro"
  }
}
```
###### 5.2 Modify instances.tf
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
  instance_type = var.server_type

  tags = {
    Name = var.server_name
  }
}
```
###### 5.3 Terraform command
```bash
terraform plan
terraform apply -auto-approve
terraform state list    //show terraform creation state
```
---
