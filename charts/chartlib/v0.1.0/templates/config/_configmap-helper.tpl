{{- /* vim: set filetype=mustache: */}}

{{- define "v1.config.configmap.meta" -}}
metadata:
  name: {{ .name }}
  namespace: {{ .context.Release.Namespace }}
  labels: {{- include "v1.helper.meta.labels" (dict "context" .context "component" .component) | nindent 4 }}
  annotations: {{- include "v1.helper.meta.annotations" (dict "context" .context "component" .component) | nindent 4 }}
{{- end -}}

{{- define "v1.config.configmap.spec" -}}
{{- /*
  TODO...
*/}}
{{- end -}}