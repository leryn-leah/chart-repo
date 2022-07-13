#!/usr/bin/env bash

kubectl delete -f gitea.yaml -n gitea
kubectl apply  -f gitea.yaml -n gitea

watch kubectl get all -n gitea
