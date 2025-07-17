# 1. EKS Pod Identity Agent
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = var.cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_version
}

#EKS VPC CNI
resource "aws_eks_addon" "VPC_CNI_agent" {
  cluster_name  = var.cluster_name
  addon_name    = "vpc-cni"
  addon_version = "v1.19.4-eksbuild.1"
}


# 2. Cluster Autoscaler
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = var.cluster_autoscaler_chart_version
  set = [{
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
    }, {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
    }, {
    name  = "awsRegion"
    value = var.aws_region
  }]



  depends_on = [aws_eks_addon.pod_identity_agent, helm_release.metrics_server]
}

# 3. AWS ALB Ingress Controller
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  # version    = var.alb_controller_chart_version

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
      }, {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
      }, {
      name  = "vpcId"
      value = var.vpc_id
    },
    {
      name  = "region"
      value = var.aws_region
    }
  ]


  depends_on = [aws_eks_addon.pod_identity_agent, helm_release.cluster_autoscaler]
}

# 4. Kubernetes Metrics Server
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = var.metrics_server_chart_version



  depends_on = [aws_eks_addon.pod_identity_agent]
}
#CSI EBS
resource "helm_release" "ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  set = [
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = "arn:aws:iam::148000812951:role/dev-ebs-csi-controller-role"
    }
  ]



  depends_on = [aws_eks_addon.pod_identity_agent]
}


#Argo-cd
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
      value = "internet-facing"
    },

  ]
}

resource "kubernetes_secret" "argocd_repo" {
  metadata {
    name      = "my-k8s-argocd-creds"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url      = var.gitlab_url
    username = var.gitlab_repo_username
    password = var.gitlab_repo_pass
  }

  type = "Opaque"

  provider   = kubernetes
  depends_on = [helm_release.argocd]
}


# 5. Prometheus 
resource "helm_release" "kube_prometheus_stack" {
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"

  create_namespace = true

  values = [file("${path.module}/values/promotheus.yaml")]


}
 