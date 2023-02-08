#!/usr/bin/env bash

set -eux

cd -P "$(dirname ${0-$BASHSOURCE})"|| exit 1
while [[ ! -e ./.git ]] ; do
  cd -P "$PWD/.." || exit 1
done

APP="$1"
helm template --debug "myapp" charts/$APP -n $APP | \
  grep --color=never "\S" 1> .$APP-charts.yaml
cat .$APP-charts.yaml
