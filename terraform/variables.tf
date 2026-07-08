variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "project_tags" {
  type = map(string)
  default = {
    Client      = "kriva"
    ManagedBy   = "Terraform"
    Project     = "kriva-Migration"
  }
}
