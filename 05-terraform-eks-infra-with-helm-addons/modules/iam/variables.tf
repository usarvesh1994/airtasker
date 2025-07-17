variable "environment" {
  description = "Environment name like dev, staging, prod"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_ready" {
  description = "Fake varibel to stop pod Identity association"
  type        = string
}

 