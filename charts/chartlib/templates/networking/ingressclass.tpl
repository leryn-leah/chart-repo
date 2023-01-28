{{/* vim: set filetype=mustache: */}}

{{- if .Values.debug -}}
{{- if eq .Values.exposureType "ingress" }}
apiVersion: {{ include "api.capabilities.ingress.apiVersion" . }}
kind: IngressClass
metadata:
  name: ""
  namespace: ""
  annotations:
    ingressclass.kubernetes.io/is-default-class: true
  labels: {}
spec:
  controller: ""
{{- end }}
{{- end -}}
