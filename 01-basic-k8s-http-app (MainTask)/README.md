# 🚀 Airtasker Kubernetes Take-Home Task

This repository demonstrates deploying a containerized Node.js application in a local Kubernetes cluster (Docker Desktop). It showcases:

- Core Kubernetes resources (Deployment, Service, Ingress)
- Observability with Prometheus metrics
- Health checks
- Secure and resilient container configuration

---

## 📁 Project Structure
 
```bash
main-task/
├── app/                # Node.js application (server.js, Dockerfile, package.json)
└── k8s-manifests/      # Kubernetes manifests
    ├── deployment.yaml
    ├── ingress.yaml
    └── service.yaml
```

---

## ⚙️ Prerequisites

- Docker Desktop with Kubernetes enabled
- `kubectl` CLI installed and configured
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) installed:
 
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
 

- Add DNS entry to `/etc/hosts`:
 
127.0.0.1 airtasker.local
 

---

## 🛠️ Setup Instructions

### 1. Build Docker Image

 
cd app
docker build -t airtasker-task:latest .

If you want to push to Docker Registry
```bash
  docker login 
```
  #### we are using to build both architectures for mac M2 and AWS t3 instances
  ```bash
  docker buildx create --use
  docker buildx build --platform linux/amd64,linux/arm64 -t usarvesh/airtasker:latest --push .

  docker tag airtasker-task:latest usarvesh/airtasker:latest
  docker push usarvesh/airtasker:latest   
```
> ℹ️ use `imagePullPolicy` set to `Never` in the manifest, so Kubernetes will use the locally built image (For local Devlopment Docker desktop). I pushed my image to Docker so i can use docker usarvesh/airtasker

---

### 2. Deploy to Kubernetes

 ```bash
kubectl create namespace airtasker
kubectl apply -f k8s-manifests/ -n airtasker
 ```

---

### 3. Test the Application

 ```bash
curl -H "Host: airtasker.local" http://localhost/
# Output: airtasker

curl -H "Host: airtasker.local" http://localhost/healthcheck
# Output: OK

curl -H "Host: airtasker.local" http://localhost/metrics
# Output: Prometheus metrics
 ```

---

## 📊 Observability

- **Metrics Endpoint:** `/metrics`
- **Prometheus-Compatible Metrics:**
  - `http_requests_total`
  - `http_request_duration_seconds`

Scrape `/metrics` with Prometheus for application-level insights.

---

## ❤️ Health Checks

- **Readiness Probe:** `/healthcheck` — delays traffic until pod is ready  
- **Liveness Probe:** `/healthcheck` — restarts pod if it's unresponsive

---

## 🔐 Security & Reliability

- Runs as **non-root**
- Drops **all Linux capabilities**
- Defines **CPU/memory requests and limits**
- Uses **rolling update strategy** for zero downtime
- Configured with **2 replicas** (per task requirement)

---

## ⚙️ Application Configuration

- **Environment Variable:** `APP_NAME=airtasker`
- **Listening Port:** 3000 (exposed via Service on port 80)
- **Docker Image:** `airtasker-task:latest`

---

## 🧼 Cleanup
 ```bash
kubectl delete namespace airtasker
 ```