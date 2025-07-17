terraform {
  required_version = "1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket       = "sarvesh-terraform-lock"
    key          = "my-new-cicd2/terraform.tfstate"
    region       = "ap-southeast-2"
    use_lockfile = true
  }
}

# AWS provider
provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "replica"
  region = "us-east-1"
}

# EKS cluster data sources
data "aws_eks_cluster" "this" {
  name       = module.eks_cluster.cluster_name
  depends_on = [module.eks_cluster]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks_cluster.cluster_name
  depends_on = [module.eks_cluster]
}

# Kubernetes provider with EKS authentication
provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token

}

# Helm provider with EKS authentication  
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
