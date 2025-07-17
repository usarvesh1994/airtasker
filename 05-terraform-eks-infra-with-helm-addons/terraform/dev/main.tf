# =====================
# 🚧 Networking (VPC, Subnets, NAT)
# =====================
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_subnet_count  = 2
  private_subnet_count = 2
  enable_nat_gateway   = true
  environment          = var.environment
  eks_clusterName      = var.cluster_name
}

# =====================
# 🔐 IAM Roles for EKS Cluster + Nodes
# =====================
module "eks_roles" {
  source        = "../../modules/iam"
  environment   = var.environment
  cluster_name  = var.cluster_name
  cluster_ready = module.eks_cluster.cluster_name
}

# =====================
# ☸️ EKS Cluster Setup
# =====================
module "eks_cluster" {
  source = "../../modules/eks-cluster"

  cluster_name                      = var.cluster_name
  cluster_version                   = var.cluster_version
  subnet_ids                        = module.vpc.private_subnet_ids
  cluster_role_arn                  = module.eks_roles.eks_cluster_role_arn
  node_role_arn                     = module.eks_roles.eks_node_role_arn
  node_group_desired_capacity       = var.node_group_desired_capacity
  node_group_min_size               = var.node_group_min_size
  node_group_max_size               = var.node_group_max_size
  node_instance_types               = var.node_instance_types
  environment                       = var.environment
  cluster_creator_admin_permissions = true
}

# =====================
# 📦 Helm Addons (ALB Controller, Autoscaler, Metrics Server, Pod Identity)
# =====================
module "helm_modules" {
  source                           = "../../modules/helm"
  vpc_id                           = module.vpc.vpc_id
  alb_service_account_name         = var.alb_service_account_name
  aws_region                       = var.aws_region
  cluster_autoscaler_chart_version = var.cluster_autoscaler_chart_version
  cluster_name                     = var.cluster_name
  metrics_server_chart_version     = var.metrics_server_chart_version
  pod_identity_version             = var.pod_identity_version

  gitlab_url           = var.gitlab_url
  gitlab_repo_username = var.gitlab_repo_username
  gitlab_repo_pass     = var.gitlab_repo_pass

  providers = {
    helm       = helm
    kubernetes = kubernetes.eks
  }

  depends_on = [module.eks_roles, module.eks_cluster]
} 