{{- /* vim: set filetype=mustache: */}}

{{- define "api.networking.ingressclass" -}}
{{- $root := . }}
{{- if eq (title .Values.exposureType) "Ingress" }}
apiVersion: {{ include "api.capabilities.ingress.apiVersion" $root }}
kind: IngressClass
metadata:
  name: ""
  annotations:
    "ingressclass.kubernetes.io/is-default-class": true
  labels: {}
spec:
  controller: ""
---
{{- end -}}
{{- end -}}
