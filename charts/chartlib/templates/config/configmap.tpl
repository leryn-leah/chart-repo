{{/* vim: set filetype=mustache: */}}

{{- if .Values.debug -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ""
  namespace: ""
  annotations: {}
  labels: {}
data: {}
{{- end -}}