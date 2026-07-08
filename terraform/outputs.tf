output "vpc_id" {
  description = "The ID of the custom kriva VPC"
  value       = module.vpc.vpc_id
}

output "eks_cluster_endpoint" {
  description = "The connection endpoint for the Amazon EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  description = "The connection string for the ITTS/OT PostgreSQL Database"
  value       = aws_db_instance.postgres.endpoint
}
