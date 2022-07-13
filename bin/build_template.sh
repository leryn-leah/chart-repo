#!/usr/bin/env bash

export HELM_EXPERIMENTAL_OCI=1

helm repo update

while read -r chart ; do
  cd -P "$PWD/charts/$chart" || exit 1

  helm dependency update \
    && helm lint -n default \
    && helm package . \
    && find . -maxdepth 1 -name "*.tgz" -exec helm cm-push {} leryn \; \
    && find . -maxdepth 1 -name "*.tgz" -exec rm {} \;

  while [[ ! -e ./.git ]] ; do
    cd -P "$PWD/.." || exit 1
  done
done< <(ls ./charts/)