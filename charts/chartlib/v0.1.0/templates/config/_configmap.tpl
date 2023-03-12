{{- /* vim: set filetype=mustache: */}}

{{- define "v1.config.configmap" -}}
{{- $context := . -}}
{{- $operator := . -}}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled }}
{{- range $configMapName, $configMap := $application.configMaps }}
apiVersion: v1
kind: ConfigMap
{{- include "v1.config.configmap.meta" (dict "name" $configMapName "context" $context "component" $applicationName) | nindent 0 }}
data:
  {{- if eq (title $configMap.type) "File" }}
  {{ base $configMap.mountPath }}: |-
    {{- $operator.Files.Get (clean $configMap.projectPath) | nindent 4 }}
  {{- end }}
  {{- /* End of File */}}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
