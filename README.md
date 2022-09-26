# Chart Repo

## TL;DR

All my charts lie here.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Build](#build)
- [Usage](#usage)
- [Related Efforts](#related-efforts)
- [Maintainers](#maintainers)
- [License](#license)

## Prerequisites

### Develop

Go check them out if you don't have them installed locally.

- [Helm](https://github.com/helm/helm): Recommended >= v3.7.0
- (*Optional**) Chart repo server: native [Chartmuseum](https://github.com/helm/chartmuseum), or recommended [Harbor](https://github.com/goharbor/harbor) which integrates chartmuseum internally.
- (*Optional**) Use `helm cm-push` command to commit charts to the remote, or install local [helm-push plugin](https://github.com/chartmuseum/helm-push).

### Runtime

- Helm
- Kubernetes

### How to install helm-push plugin

```bash
helm plugin install https://github.com/chartmuseum/helm-push.git

# Or use GitHub proxy
helm plugin install https://ghproxy.com/https://github.com/chartmuseum/helm-push.git
```

Higher than Helm v3.7.0, `helm push` becomes the helm built-in command by official, which replaced the formal Chartmuseum helm-push plugins renamed to `helm cm-push`. If using `helm push sample-1.0.0.tgz mychartrepo` as usual, the following error would occur. The easy solution is to update helm (>= v3.7.0) and reinstall helm-push plugin.

> Error: scheme prefix missing from remote (e.g. “oci://”)

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