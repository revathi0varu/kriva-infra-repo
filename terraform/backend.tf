terraform {
  # Stores the architectural state file securely in S3
  backend "s3" {
    bucket         = "kriva-telecom-tfstate-bucket" # Must match a bucket you create in AWS
    key            = "prod/infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table" # Prevents two people from running updates at once
    encrypt        = true
  }
}
