output "cluster_id" {
  description = "ID of the EKS Cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS Cluster Certificate Authority Data"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_id" {
  description = "Node Group ID"
  value       = aws_eks_node_group.this.id
}

output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}
