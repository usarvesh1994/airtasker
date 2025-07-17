variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.29"
}

variable "subnet_ids" {
  description = "Subnets IDs for EKS Cluster networking"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM Role ARN for EKS Control Plane"
  type        = string
}

variable "node_role_arn" {
  description = "IAM Role ARN for EKS Worker Nodes"
  type        = string
}

variable "node_group_desired_capacity" {
  description = "Desired number of nodes in the EKS Node Group"
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in Node Group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in Node Group"
  type        = number
  default     = 3
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "environment" {
  description = "Environment tag (dev, prod, etc.)"
  type        = string
}

variable "cluster_creator_admin_permissions" {
  description = "Creator to provide admin access"
  type = bool
  default = true
}