{{/* vim: set filetype=mustache: */}}

{{- if .Values.debug -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: ""
  namespace: ""
  annotations: {}
  labels: {}
type: Opaque
stringData: {}
{{- end -}}

{{- if .Values.debug -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: ""
  namespace: ""
type: kubernetes.io/tls
data:
  tls.key: ""
  tls.crt: ""
{{- end -}}