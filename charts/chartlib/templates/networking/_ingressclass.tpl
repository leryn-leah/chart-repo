{{- /* vim: set filetype=mustache: */}}

{{- define "v1.networking.ingressclass" -}}
{{- $root := . }}
{{- if eq (title .Values.exposureType) "Ingress" }}
apiVersion: {{ include "v1.capabilities.ingress.apiVersion" $root }}
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
