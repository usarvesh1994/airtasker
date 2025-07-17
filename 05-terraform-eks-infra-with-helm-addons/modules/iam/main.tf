# IAM Role for EKS Control Plane
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_VPC_Controller_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# IAM Role for EKS Node Group (Worker Nodes)
resource "aws_iam_role" "eks_node_role" {
  name = "${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_worker_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
  
# IAM Role for Cluster Autoscaler with Pod Identity
resource "aws_iam_role" "cluster_autoscaler_pod_identity" {
  name = "${var.environment}-cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "pods.eks.amazonaws.com"
        },
        Action = ["sts:AssumeRole", "sts:TagSession"]
      }
    ]
  })
}

resource "aws_iam_role_policy" "cluster_autoscaler_policy" {
  name = "${var.environment}-cluster-autoscaler-policy"
  role = aws_iam_role.cluster_autoscaler_pod_identity.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = aws_iam_role.cluster_autoscaler_pod_identity.arn

  depends_on = [var.cluster_ready]
}

# IAM Role for ALB Controller with Pod Identity
resource "aws_iam_role" "alb_controller_pod_identity" {
  name = "${var.environment}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "pods.eks.amazonaws.com"
        },
        Action = ["sts:AssumeRole", "sts:TagSession"]
      }
    ]
  })
}

resource "aws_iam_role_policy" "alb_controller_policy" {
  name = "${var.environment}-alb-controller-policy"
  role = aws_iam_role.alb_controller_pod_identity.id

  policy = file("${path.module}/policies/AWSLoadBalancerController.json")


}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.alb_controller_pod_identity.arn
  depends_on      = [var.cluster_ready]
}

# IAM Role for the EBS CSI driver controller  
resource "aws_iam_role" "ebs_csi_controller_pod_identity" {
  name = "${var.environment}-ebs-csi-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "pods.eks.amazonaws.com"
      },
      Action = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

# Attach the managed EBS CSI Driver policy to that role
resource "aws_iam_role_policy_attachment" "ebs_csi_controller_attach" {
  role       = aws_iam_role.ebs_csi_controller_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "ebs_csi_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"                            # update if needed
  service_account = "ebs-csi-controller-sa"                            # must match your K8s service account
  role_arn        = aws_iam_role.ebs_csi_controller_pod_identity.arn

  depends_on = [var.cluster_ready]
}

#Fargate Roles
resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_attach" {
  role       = aws_iam_role.fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}


# x-rays
resource "aws_iam_role" "xray_irsa_role" {
  name = "${var.environment}-xray-daemon-role-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::148000812951:oidc-provider/oidc.eks.ap-southeast-2.amazonaws.com/id/6C4C4CCA150E92C0DEF11A73AEF30340"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "oidc.eks.ap-southeast-2.amazonaws.com/id/6C4C4CCA150E92C0DEF11A73AEF30340:sub" = "system:serviceaccount:default:xray-daemon"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "xray_permissions" {
  name = "${var.environment}-xray-daemon-policy"
  role = aws_iam_role.xray_irsa_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries",
          "xray:PutTelemetryRecords",
          "xray:PutTraceSegments"
        ],
        Resource = "*"
      }
    ]
  })
}

# Xray rules

resource "aws_iam_role" "xray_pod_identity_role" {
  name = "${var.environment}-xray-pod-identity-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "pods.eks.amazonaws.com"
        },
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "xray_policy" {
  name = "${var.environment}-xray-policy"
  role = aws_iam_role.xray_pod_identity_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries",
          "xray:PutTelemetryRecords",
          "xray:PutTraceSegments"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "xray_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "default"                            # update if needed
  service_account = "xray-sa"                            # must match your K8s service account
  role_arn        = aws_iam_role.xray_pod_identity_role.arn

  depends_on = [var.cluster_ready]
}
