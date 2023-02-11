{{- /* vim: set filetype=mustache: */}}

{{/*
Return the target Kubernetes version
*/}}
{{- define "v1.core.objectMeta" -}}
metadata:
  name: ""
  namespace: ""
  annotations: {}
  labels: {}
{{- end -}}

{{/*
*/}}
{{- define "v1.core.objectMeta.labels" -}}
{{ $root := . }}
"app.kubernetes.io/name": {{ $root.Release.Name }}
"app.kubernetes.io/component": core
{{- end -}}