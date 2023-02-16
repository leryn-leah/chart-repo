#!/usr/bin/env bash

helm install minio minio/minio -n oss \
  --version 4.0.14 \
  --set consoleIngress.enabled=true                    \
  --set consoleIngress.hosts={oss-console.leryn.top}   \
  --set consoleIngress.ingressClassName=nginx          \
  --set ingress.enabled=true                           \
  --set ingress.hosts={oss.leryn.top}                  \
  --set ingress.ingressClassName=nginx                 \
  --set mode=standalone                                \
  --set networkPolicy.allowExternal=true               \
  --set persistence.existingClaim=oss-data-pvc         \
  --set persistence.size=5Gi                           \
  --set replicas=1                                     \
  --set resources.requests.memory=128Mi                \
  --set rootPassword=xxxxxxxxxx                        \
  --set rootUser=admin                                 \
  --set securityContext.fsGroup=0                      \
  --set securityContext.runAsUser=0                    \
  --set securityContext.runAsGroup=0