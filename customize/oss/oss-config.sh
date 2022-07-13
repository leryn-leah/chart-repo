#!/usr/bin/env bash

kubectl delete secret oss-config -n oss
kubectl create secret generic oss-config -n oss \
  --from-literal=MINIO_ROOT_USER=admin \
  --from-literal=MINIO_ROOT_PASSWORD=password
