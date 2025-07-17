# Variables for addons module

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}
/*
variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_ca_data" {
  type        = string
  description = "Base64 encoded certificate authority data"
}
*/

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "pod_identity_version" {
  type        = string
  description = "EKS pod identity agent version"
}

variable "cluster_autoscaler_chart_version" {
  type        = string
  description = "Helm chart version for cluster autoscaler"
}

# variable "alb_controller_chart_version" {
#  type        = string
#  description = "Helm chart version for AWS load balancer controller"
# }

variable "alb_service_account_name" {
  type        = string
  description = "Service account name for ALB controller"
}

variable "metrics_server_chart_version" {
  type        = string
  description = "Helm chart version for Kubernetes metrics server"
}

variable "vpc_id" {
  description = "VPC ID for ALB controller usage"
  type        = string
}

variable "kube_prometheus_stack_chart_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = "57.0.2"
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  default     = "admin123" # 🔐 Recommend passing via tfvars or using Vault/SSM for production
}


#argocd

variable "gitlab_url" {
  description = "k8s gitlab repo url"
  type        = string
  default     = "https://github.com/myorg/my-private-repo.git"
}

variable "gitlab_repo_username" {
  description = "gitlab repo username"
  type        = string
  default     = "my-username"
}

variable "gitlab_repo_pass" {
  description = "gitlab repo pass"
  type        = string
  default     = "my-git-personal-access-token"
}
