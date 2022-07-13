#/usr/bin/env bash

cd "$(dirname ${0-$BASHSOURCE})/.." || exit 1

helm template --debug gateway charts/nginx-ingress-controller -n gateway \
  --set extraArgs.default-ssl-certificate="default/leryn.top" \
  --set config.use-gzip="true" \
  --set config.gzip-level=6 \
  --set config.gzip-min-length=1k \
  --set defaultBackend.enabled=false \
  1> .nginx-ingress-controller-charts.yaml

helm template --debug gateway nginx-ingress-controller -n gateway \
  --set extraArgs.default-ssl-certificate="default/leryn.top" \
  --set config.use-gzip="true" \
  --set config.gzip-level=6 \
  --set config.gzip-min-length=1k \
  --set defaultBackend.enabled=false \
  1> .nginx-ingress-controller-charts.yaml
