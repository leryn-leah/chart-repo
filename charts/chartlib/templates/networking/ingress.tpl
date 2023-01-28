{{/* vim: set filetype=mustache: */}}

{{- if eq .Values.exposureType "ingress" -}}
{{- include "api.networking.ingress" . -}}
{{- end -}}

{{/*

*/}}
{{- define "api.networking.ingress" -}}
{{ $root := . }}
{{ $someIngress := (include "_.tplvalues.render" ( dict "value" .Values.ingress "ctx" $ "root" $root)) | fromYaml }}
{{ range $ingressName, $ingress := $someIngress }}
apiVersion: {{ include "api.capabilities.ingress.apiVersion" $ }}
kind: Ingress
metadata:
  name: {{ $root.Release.Name }}-{{ $ingressName }}
  namespace: {{ $root.Release.Namespace }}
  annotations:
    {{- if $root.commonAnnotations }}
    {{- $root.commonAnnotations | toYaml | indent 4 }}
    {{- end }}
    {{- if $ingress.annotations }}
    {{- $ingress.annotations | toYaml | indent 4 }}
    {{- end }}
  labels:
    {{- if $root.commonLabels }}
    {{- $root.commonLabels | toYaml | indent 4 }}
    {{- end }}
spec:
  {{- if $ingress.className }}
  ingressClassName: {{ $ingress.className }}
  {{- end }}
  hosts:
    - host: core.domain.com
      paths:
        - path: /
          pathType: ImplementationSpecific
{{/*          backend:*/}}
{{/*            service:*/}}
{{/*              name: {{ $root.Release.Name }}-{{ $ingressName }}*/}}
{{/*              port:*/}}
{{/*                number: 8080*/}}
  {{- if $ingress.tls }}
  tls:
    - hosts:
      - ""
      secretName: ""
  {{- end }}
---
{{- end -}}
{{- end -}}
