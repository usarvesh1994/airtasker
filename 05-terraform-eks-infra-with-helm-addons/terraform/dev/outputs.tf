
output "AWS_REGION" {
  value = var.aws_region
}

 output "debug_cluster_endpoint" {
  value = data.aws_eks_cluster.this.endpoint
}

output "debug_cluster_name" {
  value = data.aws_eks_cluster.this.name
}

output "debug_cluster_status" {
  value = data.aws_eks_cluster.this.status
}