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