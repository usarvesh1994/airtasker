output "eks_cluster_role_arn" {
  description = "IAM Role ARN for the EKS Cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "IAM Role ARN for the EKS Node Group"
  value       = aws_iam_role.eks_node_role.arn
}

# Outputs
output "cluster_autoscaler_role_arn" {
  value = aws_iam_role.cluster_autoscaler_pod_identity.arn
}

# Outputs
output "cluster_autoscaler_pod_identity_role_arn" {
  value = aws_iam_role.cluster_autoscaler_pod_identity.arn
}

output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller_pod_identity.arn
}

output "xray_pod_identity_role" {
  value = aws_iam_role.xray_pod_identity_role.arn
}

output "fargate_pod_execution_role_arn" {
  value = aws_iam_role.fargate_pod_execution_role.arn
}
