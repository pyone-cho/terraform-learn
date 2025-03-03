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