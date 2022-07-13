#!/usr/bin/env bash

sh +x oss-config.sh

kubectl delete -f oss.yaml -n oss
kubectl apply  -f oss.yaml -n oss

watch kubectl get all -n oss
