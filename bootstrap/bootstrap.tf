provider "aws" {
  region = "us-east-1"
}

# 1. Create the S3 Bucket for state file storage
resource "aws_s3_bucket" "state_bucket" {
  bucket        = "kriva-telecom-tfstate-bucket"
  force_destroy = true # Allows easy cleanup if you destroy the project later
}

# Enable versioning so you have a history of your infrastructure changes
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 2. Create the DynamoDB Table for state locking
resource "aws_dynamodb_table" "lock_table" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
