#  Project Walkthrough – Airtasker Take-Home Assignment

Thank you for the opportunity to demonstrate my DevOps and Kubernetes skills through this assignment. Below is a structured summary of each project folder, what it contains, and how it contributes to showcasing real-world skills in Kubernetes, GitOps, observability, infrastructure-as-code, and multi-environment deployments.

---

## 📁 Folder Overview

### `01-basic-k8s-http-app/`
A simple Kubernetes application that:
- Exposes two endpoints: `/` and `/healthcheck`
- Uses environment variable injection (`APP_NAME`)
- Includes readiness and liveness probes
- Built with proper securityContext and resource limits

> ✅ Used to demonstrate a clean, secure, containerized Node.js app.

---

### `02-k8s-nginx-canary-deployment/`
Demonstrates **canary deployments** using **NGINX Ingress**:
- Two deployments: `airtasker-task` and `airtasker-task-v2`
- Canary controlled via NGINX Ingress annotations:
  - `nginx.ingress.kubernetes.io/canary: "true"`
  - Header-based routing or weight-based control
- Different environment variable passed to each version

> ✅ Shows safe release strategy and traffic splitting using ingress annotations.

---

### `03-kustomize-multi-environment-deployment/`
A **Kustomize**-based setup for multiple environments:
- `base/`: shared deployment, service, ingress
- `overlays/dev`: dev-specific namespace and image tag
- `overlays/prod`: prod-specific overrides

> ✅ Demonstrates environment separation, deployment consistency using Kustomize.

---

### `04-eks-gitops-argocd-observability/`
A **GitOps-based production-grade deployment**:
- Uses **Argo CD** with:
  - `app-of-apps` pattern
  - `ApplicationSet` for multi-env rollout
- Canary deployment via **AWS ALB Ingress Controller**
- Integrated **Prometheus ServiceMonitor** for observability
- Includes **Horizontal Pod Autoscaler (HPA)**

> ✅ Combines GitOps, observability, autoscaling, and safe rollout techniques.

---

### `05-terraform-eks-infra-with-helm-addons/`
Infrastructure provisioning using **Terraform modules**:
- Sets up VPC, subnets, EKS cluster, IAM roles
- Bootstraps core addons via Helm:
  - AWS Load Balancer Controller
  - Metrics Server
  - Cluster Autoscaler
  - Argo CD
  - CSI EBS Driver
- Prometheus is also installed using Prometheus Community Helm chart
- Argo CD configured with initial secret + HTTPS ingress

> ✅ Demonstrates real-world IaC (Infrastructure as Code) and addon provisioning at cluster bootstrap.

---

## 🧭 Suggested Flow for Review

1. Start with `01-basic-k8s-http-app` to validate app functionality.
2. Review `02-k8s-nginx-canary-deployment` for NGINX Ingress traffic routing.
3. Explore `03-kustomize-multi-environment-deployment` for multi-env structure.
4. Dive into `04-eks-gitops-argocd-observability` to see GitOps, autoscaling, and monitoring in action.
5. End with `05-terraform-eks-infra-with-helm-addons` to evaluate how the infrastructure is provisioned and managed.

---

Thank you again for taking the time to evaluate my work. Please let me know if you'd like a walkthrough of any part of the solution in more detail.

— Sarvesh Udutha
