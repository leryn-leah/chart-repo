#!/usr/bin/env bash

cd -P "$(dirname ${0-$BASHSOURCE})"|| exit 1
while [[ ! -e ./.git ]] ; do
  cd -P "$PWD/.." || exit 1
done

APP="$1"
helm template --debug $APP charts/$APP -n $APP 1> .$APP-charts.yaml
cat .$APP-charts.yaml
