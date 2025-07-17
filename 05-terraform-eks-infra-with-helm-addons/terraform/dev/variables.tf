#VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16" # Dev CIDR block
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "environment" {
  description = "Environment name"
  default     = "dev"
}



#EKS 
variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "eks-cluster"
}
variable "cluster_version" {
  default = "1.32"
}

variable "node_group_desired_capacity" {
  default = 1
}
variable "node_group_min_size" {
  default = 1
}
variable "node_group_max_size" {
  default = 3
}
variable "node_instance_types" {
  default = ["m5.large"]
}
 

#Helm
variable "alb_service_account_name" {
  description = "alb_service_account_name"
  type        = string
  default     = "aws-load-balancer-controller"

}

variable "cluster_autoscaler_chart_version" {
  description = "cluster_autoscaler_chart_version"
  type        = string
  default     = "9.37.0"

}

variable "metrics_server_chart_version" {
  description = "metrics_server_chart_version"
  type        = string
  default     = "3.12.1"
}

variable "pod_identity_version" {
  description = "pod_identity_version"
  type        = string
  default     = "v1.3.5-eksbuild.2"
}
 
#ArgoCD
variable "gitlab_url" {
  description = "k8s gitlab repo url"
  type        = string
  default     = "https://github.com/usarvesh1994/gitops.git"
}

variable "gitlab_repo_username" {
  description = "gitlab repo username"
  type        = string
  default     = "usarvesh1994"
}

variable "gitlab_repo_pass" {
  description = "gitlab repo pass"
  type        = string
  default     = "github_pat_11AOX"
}


variable "aws_region" {
  default = "ap-southeast-2"
}