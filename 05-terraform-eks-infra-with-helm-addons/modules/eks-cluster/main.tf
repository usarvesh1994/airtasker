
# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = var.cluster_creator_admin_permissions
  }

  version = var.cluster_version


  tags = {
    Environment = var.environment
  }
}

#OIDC
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd40c4d"]  # Default for AWS OIDC
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = {
    Environment = var.environment
  }
}


# EKS Node Group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.node_instance_types
 # ami_type       = "AL2023_ARM_64_STANDARD"  # ✅ Update this for Graviton (ARM)
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = var.node_group_desired_capacity
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  

  tags = {
    Environment = var.environment
  }
} 