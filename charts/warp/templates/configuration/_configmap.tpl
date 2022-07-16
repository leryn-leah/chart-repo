{{/*
  ConfigMap
==============================
*/}}
{{- define "api.configuration.configmap" -}}
{{- range $deployName, $deploy := .Values.application }}
{{- range $configMap := .configMaps }}
{{- $configMapName := $configMap.name | replace "." "-" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configMapName }}-cm
  namespace: {{ include "api.namespace.name" $ }}
data:
  {{ $configMap.name }}: |-
  {{- if $configMap.values }}
    {{- $configMap.values | nindent 4 }}
  {{- else }}
    {{ printf "conf/%s" $configMap.conf | $.Files.Get | nindent 4 }}
  {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}