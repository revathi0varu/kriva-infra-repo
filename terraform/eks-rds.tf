# --- 1. AMAZON EKS CLUSTER ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "kriva-${var.environment}-eks"
  cluster_version = "1.28"

  create_node_security_group = true
  manage_node_security_group = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  # Managed Node Group: Automatically sets up scaling EC2 worker nodes
  eks_managed_node_groups = {
    general_workers = {
      min_size       = 2
      max_size       = 4
      desired_size   = 3
      instance_types = ["t3.medium"] # Gives your Java Spring Boot apps plenty of RAM to run smoothly
    }
  }
  tags = var.project_tags
}

# --- 2. RDS DATABASE SECURITY GROUP ---
resource "aws_security_group" "rds_sg" {
  name        = "kriva-rds-sg"
  vpc_id      = module.vpc.vpc_id

  # Strict Rule: Inbound PostgreSQL traffic allowed ONLY from within the EKS cluster
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- 3. AMAZON RDS POSTGRESQL INSTANCE ---
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  db_name                = "krivadb"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t3.micro"
  username = "db_admin"
  password = random_password.db_password.result
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  deletion_protection = var.environment == "production" ? true : false
  skip_final_snapshot = var.environment == "production" ? false : true
  tags = var.project_tags
}
