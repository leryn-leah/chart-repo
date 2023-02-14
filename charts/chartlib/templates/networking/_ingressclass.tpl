{{- /* vim: set filetype=mustache: */}}

{{- define "v1.networking.ingressclass" -}}
{{- $context := . }}
{{- if eq (title .Values.exposureType) "Ingress" }}
apiVersion: {{ include "v1.capabilities.ingress.apiVersion" $context }}
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
