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
