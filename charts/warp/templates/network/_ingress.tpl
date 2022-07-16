{{/**
  Ingress
==============================
*/}}
{{- define "api.network.ingress" -}}
{{- if .Values.exposure.enabled -}}
{{- if eq .Values.exposure.type "ingress" -}}
{{ $apiVersion := include "internal.network.ingress.apiVersion" . }}
{{ range $ingressName, $ingress := .Values.exposure.ingress -}}
apiVersion: {{ include "internal.network.ingress.apiVersion" $ }}
kind: Ingress
metadata:
  name: {{ $ingressName }}-ingress
  namespace: {{ include "api.namespace.name" $ }}
  annotations:
  {{- if $ingress.annotations }}
    {{- $ingress.annotations | toYaml | nindent 4 }}
  {{- end }}
spec:
  {{- if $ingress.class }}
  ingressClassName: {{ $ingress.class }}
  {{- end }}
  rules:
  - host: {{ include "utils.tplvalues.render" ( dict "value" .hostname "context" $ ) }}
    http:
      paths:
        - backend:
          {{- include "internal.network.ingress.backend" ( dict "serviceName" $ingressName "servicePort" 80 "context" $) | nindent 12 }}
          path: {{ .path }}
          {{- if eq "true" (include "internal.network.ingress.supportsPathType" $) }}
          pathType: Prefix
          {{- end }}
  {{- if .secrets }}
  tls:
  - hosts:
    - {{ $ingress.hostname | quote }}
    secretName: {{ $ingress.hostname }}
  {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}