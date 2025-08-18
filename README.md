# Data on EKS Project with Kind, NGINX, Spark and Portainer

This project contains the infrastructure and application configuration using **Kustomize** for orchestration in a local **Kubernetes** cluster with **Kind**.  
It includes deployments of services such as **Spark**, **Portainer**, **Echo Server**, and support for batch jobs.

---

## Project Structure

```
kustomize/
├── apps/                # Managed applications
│   ├── echo/            # Echo server (deployment + service + kustomization)
│   ├── spark/           # Apache Spark (master, workers, ingress, statefulset)
│   ├── portainer/       # Portainer (deployment, pvc, svc, ingress)
│   └── job-batch/       # Spark batch job
│
├── infra/               # Cluster infrastructure
│   ├── nginx/           # Ingress NGINX configs
│   └── local-path/      # Local storage provisioner
│
├── ingress/             # Service ingress configurations
│   ├── echo.ing.yaml
│   ├── portainer.ing.yaml
│   └── spark.ing.yaml
│
├── scripts/             # Automation
│   ├── apply-infra.sh   # Sets up infrastructure (Kind + kustomize infra)
│   ├── apply-apps.sh    # Deploys applications
│   └── kind-config.yaml # Base Kind cluster configuration
```

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)  
- [Kind](https://kind.sigs.k8s.io/)  
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)  
- [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)  

---

## Getting Started

### 1. Create and configure the cluster
```bash
cd kustomize/scripts
./apply-infra.sh
```
This script creates a **Kind** cluster and applies the infrastructure manifests (NGINX ingress + Local Path Provisioner).

### 2. Deploy the applications
```bash
./apply-apps.sh
```
This script applies the manifests for **Spark**, **Echo Server**, and **Portainer**.

---

## Available Services

- **Portainer**: Container management  
  - Ingress: `http://localhost/portainer`

- **Echo Server**: HTTP request test  
  - Ingress: `http://localhost/echo`

- **Apache Spark**: Distributed jobs management UI  
  - Ingress: `http://localhost/spark`

To simplify access, you can map local domains in the `/etc/hosts` file.  
Example configuration (assuming the ingress controller is running on `127.0.0.1`):

```bash
sudo nano /etc/hosts

127.0.0.1   portainer.local
127.0.0.1   echo.local
127.0.0.1   spark.local
```

---

## Additional Notes

- All ingresses are configured via the **NGINX Controller**.  
- The `workers-statefulset.yaml` allows scalability of **Spark Workers** (not currently used).
