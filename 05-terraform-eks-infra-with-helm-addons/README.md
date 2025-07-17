
# 🚀 Airtasker AWS EKS Infrastructure (Terraform)

This repository defines the Terraform-based infrastructure setup for deploying an EKS cluster on AWS with essential Kubernetes platform components and GitOps tooling.

---

## 🧱 Modules & Architecture Overview

This Terraform configuration uses a modular structure to provision:

- 🛡️ **VPC + Subnets + NAT Gateway**
- 🔐 **IAM Roles** for EKS cluster and nodes
- ☸️ **EKS Cluster** (with managed node groups)
- 📦 **Helm Addons**, including:
  - ✅ AWS Load Balancer Controller
  - ✅ Cluster Autoscaler
  - ✅ Metrics Server
  - ✅ EBS CSI Driver
  - ✅ Argo CD
  - ✅ Kubernetes Dashboard
  - ✅ Kubernetes Secrets (for Argo CD)
  - ✅ Prometheus (via community Helm chart) 

---

## 📁 Module Breakdown

### 1. `vpc` Module

Creates:
- VPC
- 2 Public + 2 Private subnets
- NAT Gateway
- Tags for `kubernetes.io/role/...` to support ALB Ingress Controller

### 2. `eks_roles` Module

Creates:
- IAM roles and policies for:
  - EKS control plane
  - Worker node groups
  - Service accounts

### 3. `eks_cluster` Module

Creates:
- EKS cluster with:
  - Custom version (`cluster_version`)
  - Node groups (with scaling config)
- Admin access enabled for creator

### 4. `helm_modules` Module

Installs via Helm:
- 🚀 **ALB Ingress Controller** for exposing workloads via AWS Load Balancer
- ⚙️ **Cluster Autoscaler** to scale node groups based on demand
- 📊 **Metrics Server** for HPA and monitoring
- 🔌 **EBS CSI Driver** for dynamic EBS volume provisioning
- 🧠 **Argo CD** for GitOps-driven app delivery
- 🔐 **Kubernetes Secrets** for Argo CD repo credentials
- 📈 **Prometheus (Community)** with TLS enabled for secure metrics scraping

---

## 🔐 GitOps Integration

- Credentials for GitOps (GitLab or GitHub) are securely passed via variables:
  
  gitlab_repo_username = var.gitlab_repo_username
  gitlab_repo_pass     = var.gitlab_repo_pass
 

---

## 🚀 How to Use

### 1. Initialize Terraform


terraform init


### 2. Plan the Deployment

terraform plan -out=tfplan


### 3. Apply the Infrastructure

terraform apply tfplan


---

## 📌 Notes

- All addons are deployed using `helm` provider and `kubernetes` provider (`eks` context).
- `depends_on` ensures the addons install only after the cluster is ready.
- Argo CD is used for GitOps; after provisioning, sync your app-of-apps from Git.

 