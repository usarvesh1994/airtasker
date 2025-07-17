
# 🚀 Airtasker – Multi-Environment Deployment with Kustomize

This example showcases how to deploy the same Kubernetes base resources to multiple environments (e.g., dev, prod) using **Kustomize**. Each environment customizes settings like namespace, image tags, and name prefixes.

---

## 📁 Folder Structure

  ```bash
kustomize-multi-env-deploy/
├── base/
│   ├── deployment.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    ├── dev/
    │   ├── namespace.yaml
    │   └── kustomization.yaml
    └── prod/
        ├── namespace.yaml
        └── kustomization.yaml
  ```

---

## ⚙️ Setup Instructions

### 1. 🧰 Prerequisites

- Docker Desktop with Kubernetes enabled
- `kubectl` and `kustomize` installed (or use `kubectl apply -k`)
- Local DNS entry in `/etc/hosts`:
 
  127.0.0.1 airtasker.local
 

---

### 2. 🛠️ Build Docker Image

Inside the root folder with `server.js` and `Dockerfile`:
 ```bash
cd app
docker build -t airtasker-task:latest .
 ```
If you want to push to Docker Registry
 ```bash
  docker login 
  docker tag airtasker-task:latest usarvesh/airtasker:latest
  docker push usarvesh/airtasker:latest   
 ```

> ℹ️ `imagePullPolicy` is set to `Never` in the manifest, so Kubernetes will use the locally built image. I pushed my image to Docker so i can use docker usarvesh/airtasker

---

### 3. 🧪 Deploy to Development Environment

 ```bash
kubectl apply -k overlays/dev
 
 ```
This will create resources in the `airtasker-dev` namespace with names prefixed as `dev-*`.

---

### 4. 🚀 Deploy to Production Environment

 ```bash
kubectl apply -k overlays/prod
  ```

This will create resources in the `airtasker-prod` namespace with names prefixed as `prod-*`.

---

## 🔍 What Kustomize Does

- 🏷️ Adds prefixes (`dev-`, `prod-`) to resource names
- 🗂️ Assigns different namespaces for each environment
- 🐳 Applies a different image tag or version per environment
- 🔄 Reuses the same base manifests for consistency and maintainability

---

## ✅ Clean Up

To delete a specific environment's resources:

 ```bash
kubectl delete -k overlays/dev
kubectl delete -k overlays/prod
  ```

---

## 📌 Notes

- Both environments use the same app code and structure.
- Namespace and image tag can be varied as needed.
- This structure is GitOps and CI/CD friendly.
