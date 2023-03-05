## 

Add dependencies in `Chart.yaml` and update the library.

```yaml
dependencies:
  - name: chartlib
    repository: https://harbor.leryn.top/chartrepo/library
    version: a.b.c
```

```bash
helm repo update
helm dep update
```

Add new YAML file simply writes the content below:

```gotemplate
{{- include "apis.v1.all" . -}}
```

## Values

// TODO

## YAML Schema

The schema validation is the builtin functionality in Helm. If the `values.schema.json` lies in the project root, the value schema would be validated by Helm. Copy the `values.schema.json` file to the project root.

Using go command line tools, debug the schema and validate your `values.yaml`.

```bash
helm install RELEASE_NAME . --dry-run

# or CLI tools for details.
go install github.com/neilpa/yajsv@v1.4.1
yajsv -s values.schema.json values.yaml
```

or validate schema online:

[http://json-schema.org/understanding-json-schema/index.html](http://json-schema.org/understanding-json-schema/index.html)

Reference:
- [http://json-schema.org/understanding-json-schema/index.html](http://json-schema.org/understanding-json-schema/index.html)
- [https://www.jsonschemavalidator.net/](https://www.jsonschemavalidator.net/)
- [https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23)
- [https://kubernetesjsonschema.dev/v1.18.0/_definitions.json](https://kubernetesjsonschema.dev/v1.18.0/_definitions.json)


## Develop

### Tricks

It is a hacking trick to overwrite/overlap the helm template. If a template does not meet the business requirement, create a helm template with the same name.

### Predefined Sidecar and InitContainer

Library provides series of predefined container template for sidecars and init containers. Those would be rendered in the same way as the business container.

```bash
# List all templates
find . -name "*.yaml" -o -name "*.tpl" -exec grep -E "{{- define \".*\" -}}" {} \; | awk '{print $3}'
```

### How to add a new predefined sidecar ?

Add go template `v1.workload.sidecar.newSidecar` and `v1.workload.newSidecar.values`. Library uses the field `vars` to transfer the variables to the sidecar template. The template reads the external K-V pairs under `vars` to render the sidecar.

```gotemplate
{{- define "v1.workload.sidecar.newSidecar" -}}
  {{- include "v1.workload.application.container" (include "v1.workload.sidecar.newSidecar.values" . | fromYaml ) }}
{{- end -}}
```

```gotemplate
{{- define "v1.workload.newSidecar.values" -}}
image:
  repository: sidecar
  tag: latest
{{- end -}}
```

Finally, add related values in `values.yaml`

```yaml
components:
  container:
    
    predefinedSidecars:
      - name: "sidecarName"
        type: "sidecarType"
        vars: {}

...

```

