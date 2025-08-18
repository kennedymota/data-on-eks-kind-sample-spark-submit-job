#!/usr/bin/env bash
set -euo pipefail

# sanity checks: ingress pronto?
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller

# aplica todos os apps (echo, portainer, spark)
kubectl apply -k "$(dirname "$0")/../apps"

echo "✅ Apps aplicados."
echo "Adicione ao /etc/hosts do HOST (se ainda não tiver):"
echo "  127.0.0.1 echo.local"
echo "  127.0.0.1 portainer.local"
echo "  127.0.0.1 spark.local"
echo
echo "Teste:"
echo "  curl -I http://echo.local/"
echo "  curl -I http://portainer.local/"
echo "  # UI do Spark (se criar um ingress depois): http://spark.local/"
