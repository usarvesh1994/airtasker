# Outputs for addons module

output "cluster_autoscaler_status" {
  value       = helm_release.cluster_autoscaler.status
  description = "Status of the cluster autoscaler release"
}

output "alb_controller_status" {
  value       = helm_release.aws_load_balancer_controller.status
  description = "Status of the AWS load balancer controller release"
}

output "metrics_server_status" {
  value       = helm_release.metrics_server.status
  description = "Status of the Kubernetes metrics server release"
}
