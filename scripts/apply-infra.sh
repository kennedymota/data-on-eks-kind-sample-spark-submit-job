#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${CLUSTER:-my-cluster}"

# 1) cria cluster (se ainda não existir)
if ! kind get clusters | grep -qx "$CLUSTER"; then
  kind create cluster --name "$CLUSTER" --config "$(dirname "$0")/kind-config.yaml"
fi
kind export kubeconfig --name "$CLUSTER"

# tenta pelo label novo (k8s >=1.24)
CTRL_NODE="$(kubectl get nodes -l 'node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')"

# se não achar, tenta pelo label antigo (k8s <=1.23)
if [ -z "$CTRL_NODE" ]; then
  CTRL_NODE="$(kubectl get nodes -l 'node-role.kubernetes.io/master' -o jsonpath='{.items[0].metadata.name}')"
fi

# fallback pelo nome (Kind padrão)
if [ -z "$CTRL_NODE" ]; then
  CTRL_NODE="$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -m1 control-plane || true)"
fi

if [ -z "$CTRL_NODE" ]; then
  echo "[erro] Não foi possível identificar o nó control-plane." >&2
  kubectl get nodes -o wide
  exit 1
fi

echo "-> Control-plane: $CTRL_NODE"

# rótulo exigido pelo manifest do Kind (agenda o controller no nó rotulado)
kubectl label node "${CTRL_NODE}" ingress-ready=true --overwrite

# remove o label de outros nós (garantindo que só o control-plane receba)
for N in $(kubectl get nodes -o name | sed 's|node/||' | grep -v "^${CTRL_NODE}$"); do
  kubectl label node "$N" ingress-ready- 2>/dev/null || true
done

# aplica a infra (nginx ingress + patch de nodeSelector)
kubectl apply -k "$(dirname "$0")/../infra"

# espera o controller
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller

# mostra onde foi agendado
kubectl -n ingress-nginx get pods -o wide -l app.kubernetes.io/component=controller
echo "✅ Infra OK (Ingress NGINX pronto)."
