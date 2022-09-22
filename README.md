# Chart Repo

## TL;DR

All my charts lie here.

## Install

### Prerequisites

### Develop

Go check them out if you don't have them installed locally.

- [Helm](https://github.com/helm/helm)
- (Optional*) Chart repo server: native [Chartmuseum](https://github.com/helm/chartmuseum), or recommended [Harbor](https://github.com/goharbor/harbor) which integrates chartmuseum internally.
- (Optional*) Use `helm push` command to commit charts to the remote, or install local [helm-push plugin](https://github.com/chartmuseum/helm-push).

### Runtime

- Helm and Kubernetes

### How to install helm-push plugin

```bash
helm plugin install https://github.com/chartmuseum/helm-push.git
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
helm repo add leryn https://harbor.leryn.top/chartrepo/library

bin/build_template.sh
```

## Usage

All my charts lie here.

## Related Efforts

Those repos are referenced on:

- [bitnami/charts](https://github.com/bitnami/charts)

## Maintainers

[@Leryn](https://github.com/leryn1122).

## License

[MIT](LICENSE) © Leryn