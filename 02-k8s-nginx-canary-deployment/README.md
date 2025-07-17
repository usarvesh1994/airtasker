
# 🚀 Airtasker – Canary Deployment with NGINX Ingress

This setup demonstrates a 🐳 canary release using two separate Deployments, Services, and Ingress resources. Traffic is routed between a base version and a canary version of the application using NGINX ingress annotations.

---

## 📁 Folder Structure

 ```bash
canary-deployment/
├── base/
│   ├── deployment.yaml         # Base Deployment (airtasker-task)
│   ├── service.yaml            # Base Service
│   └── ingress.yaml            # Base Ingress
├── canary/
│   ├── deployment.yaml         # Canary Deployment (airtasker-task-canary)
│   ├── service.yaml            # Canary Service
│   └── ingress.yaml            # Canary Ingress with canary annotations
 ```

---

## ⚙️ Setup Instructions

### 1. 🧰 Prerequisites

- Docker Desktop with Kubernetes enabled
- NGINX Ingress Controller installed
- Local DNS entry in `/etc/hosts`:


127.0.0.1 airtasker.local


---

### 2. 🛠️ Build Docker Image Locally

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

### 3. 🧱 Create Namespace

 ```bash
kubectl create namespace airtasker
 ```


---

### 4. 📦 Apply Kubernetes Resources

> 💡 Order matters: deploy services first to avoid race conditions.


# Base version
 ```bash
kubectl apply -f base/deployment.yaml -n airtasker
kubectl apply -f base/service.yaml -n airtasker
kubectl apply -f base/ingress.yaml -n airtasker
 ```
 
# Canary version
```bash
kubectl apply -f canary/deployment.yaml -n airtasker
kubectl apply -f canary/service.yaml -n airtasker
kubectl apply -f canary/ingress.yaml -n airtasker
 ```

---

## 🔍 How It Works

- **Base Ingress** serves most traffic (default route)
- **Canary Ingress** is enabled with:

we are sending the env value airtasker and airtasker-canary to teh pod with env varialble.


  nginx.ingress.kubernetes.io/canary: "true"
  nginx.ingress.kubernetes.io/canary-weight: "50"


- This means **50% of all incoming traffic** to `airtasker.local` will be routed to the canary version 🎯

---

## 🧪 Test the Application

Send multiple requests to observe split routing:
```bash
for i in {1..10}; do curl -H "Host: airtasker.local" http://localhost/; done
 ```

Expected output: about 5 should return `airtasker`, 5 should return `airtasker-canary`.

---

## 🩺 Health Checks

Both deployments expose `/healthcheck` for readiness and liveness 💓

---

## 🔐 Security

- Containers run as non-root 🧍‍♂️
- Dropped all Linux capabilities 🧯
- Defined CPU & memory resource limits 📉
- Zero downtime rolling updates 🔁

---

## 🧹 Cleanup

To delete everything:

 ```bash
kubectl delete namespace airtasker
  ```

---

## ✅ Summary

This setup demonstrates a safe and controlled way to do gradual rollouts using Ingress-based canary deployments in Kubernetes 🚦
