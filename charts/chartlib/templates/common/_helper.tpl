{{- /* vim: set filetype=mustache: */}}

{{/*
Return the target Kubernetes version
*/}}
{{- define "api.core.objectMeta" -}}
metadata:
  name: ""
  namespace: ""
  annotations: {}
  labels: {}
{{- end -}}

{{/*
*/}}
{{- define "api.core.objectMeta.labels" -}}
{{ $root := . }}
"app.kubernetes.io/name": {{ $root.Release.Name }}
"app.kubernetes.io/component": core
{{- end -}}