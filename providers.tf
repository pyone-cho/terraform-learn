# 1- Terraform Block and attach s3 for backend
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
