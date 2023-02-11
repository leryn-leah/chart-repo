{{- /* vim: set filetype=mustache: */}}

{{- define "v1.config.configmap" -}}
{{- $root := . -}}
{{- $operator := . -}}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled }}
{{- range $configMapName, $configMap := $application.configMaps }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configMapName }}
  namespace: {{ $root.Release.Namespace }}
  labels:
    "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
    "app.kubernetes.io/component": {{ quote $applicationName }}
  annotations: {}
data:
  {{- if eq (title $configMap.type) "File" }}
  {{ base $configMap.mountPath }}: |-
    {{- $operator.Files.Get (clean $configMap.projectPath) | nindent 4 }}
  {{- end }}
  {{/* End of File */}}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
