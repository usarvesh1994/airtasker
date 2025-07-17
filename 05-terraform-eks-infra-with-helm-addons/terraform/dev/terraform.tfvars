#VPC
vpc_cidr_block     = "10.0.0.0/16"
availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]
environment        = "dev"

#EKS
cluster_name                = "eks-cluster"
node_group_desired_capacity = 1
node_group_min_size         = 1
node_group_max_size         = 3
node_instance_types         = ["t3.medium"]

/*
gitlab_url="Your Githib/Gitlab argocd Url"
gitlab_repo_username="Username"
gitlab_repo_pass="Personal Access token"
*/