# Projeto Kubernetes com Kustomize

Este projeto contém a configuração de infraestrutura e aplicações utilizando **Kustomize** para orquestração em um cluster **Kubernetes** local com **Kind**.  
Inclui deploys de serviços como **Spark**, **Portainer**, **Echo Server** e suporte a batch jobs.

---

## Estrutura do Projeto

```
kustomize/
├── apps/                # Aplicações gerenciadas
│   ├── echo/            # Echo server (deploy + service + kustomization)
│   ├── spark/           # Apache Spark (master, workers, ingress, statefulset)
│   ├── portainer/       # Portainer (deploy, pvc, svc, ingress)
│   └── job-batch/       # Job de batch Spark
│
├── infra/               # Infraestrutura do cluster
│   ├── nginx/           # Ingress NGINX configs
│   └── local-path/      # Storage provisioner local
│
├── ingress/             # Ingress para os serviços
│   ├── echo.ing.yaml
│   ├── portainer.ing.yaml
│   └── spark.ing.yaml
│
├── scripts/             # Automação
│   ├── apply-infra.sh   # Sobe infraestrutura (Kind + kustomize infra)
│   ├── apply-apps.sh    # Aplica as aplicações
│   └── kind-config.yaml # Configuração base do cluster Kind
```

---

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)  
- [Kind](https://kind.sigs.k8s.io/)  
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)  
- [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)  

---

## Como iniciar

### 1. Criar e configurar o cluster
```bash
cd kustomize/scripts
./apply-infra.sh
```
O script cria um cluster **Kind** e aplica os manifests de infraestrutura (NGINX ingress + Local Path Provisioner).

### 2. Aplicar as aplicações
```bash
./apply-apps.sh
```
Este script aplica os manifests de **Spark**, **Echo Server** e **Portainer**.

---

## Serviços disponíveis

- **Portainer**: Gerenciamento de containers  
  - Ingress: `http://localhost/portainer`

- **Echo Server**: Teste de requests HTTP  
  - Ingress: `http://localhost/echo`

- **Apache Spark**: Interface de gerenciamento de jobs distribuídos  
  - Ingress: `http://localhost/spark`


Para facilitar o acesso, você pode mapear domínios locais no arquivo `/etc/hosts`.  
Exemplo de configuração (assumindo que o ingress controller está em `127.0.0.1`):

```bash
sudo nano /etc/hosts

127.0.0.1   portainer.local
127.0.0.1   echo.local
127.0.0.1   spark.local

---

## Notas adicionais

- Todos os ingressos estão configurados via **NGINX Controller**.  
- O `workers-statefulset.yaml` permite escalabilidade de **Spark Workers** (não utilizado).

---
