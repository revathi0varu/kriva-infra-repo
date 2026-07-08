module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "kriva-${var.environment}-vpc"
  cidr = "10.0.0.0/16"

  # Spread across 3 Availability Zones for high availability
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  database_subnets             = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  create_database_subnet_group = true

  # Enable NAT Gateway so your private K8s nodes can pull base images
  enable_nat_gateway = true
  single_nat_gateway = true

  # Essential tags for the AWS ALB Ingress Controller to find subnets auto-magically
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = var.project_tags
}
