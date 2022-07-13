# Chart Repo

All my charts lie here.

## Install

### Prerequisites

This project uses [helm](https://github.com/helm/helm) and [chartmuseum](https://github.com/helm/chartmuseum). Go check them out if you don't have them locally installed.

### Plugins

Install local [helm-push plugin](https://github.com/chartmuseum/helm-push).

```bash
helm plugin install git://github.com/chartmuseum/helm-push.git
```

## Build

Use the bash script to vendor the helm chart locally under the `charts/*`

```bash
bin/vendor_template.sh sample
cat .sample-charts.yaml
```

Use the bash script to build the helm repo.

```bash
# Add your helm repo first.
helm repo add leryn https://harbor.leryn.top/chartrepo/leryn

bin/build_template.sh
```

