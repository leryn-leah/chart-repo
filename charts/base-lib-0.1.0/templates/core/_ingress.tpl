{{- define "charts.core.ingress" -}}
{{/**
  Ingress
==============================
*/}}
{{- if eq .Values.exposure.type "ingress" -}}
{{ $ingress := .Values.exposure.ingress -}}
apiVersion: {{ include "charts.core.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: ingress
  namespace: {{ include "charts.core.namespace.name" . }}
  labels:
    {{- include "charts.common.labels" . | nindent 4 }}
  annotations:
  {{- if $ingress.annotations }}
    {{- $ingress.annotations | toYaml | nindent 4 }}
  {{- end }}
  {{- if .Values.commonAnnotations }}
    {{- .Values.commonAnnotations | toYaml | nindent 4 }}
  {{- end }}
spec:
  {{- if $ingress.class }}
  ingressClassName: {{ $ingress.class }}
  {{- end }}
  rules:
  - host: {{ include "utils.tplvalues.render" ( dict "value" .Values.exposure.ingress.hostname "context" $ ) }}
    http:
      paths:
        - backend:
          {{- include "charts.core.ingress.backend" (dict "serviceName" "fuck" "servicePort" (ternary "https" "http" .Values.internalTLS) "context" $) | nindent 12 }}
          path: "/"
          {{- if eq "true" (include "charts.ingress.supportsPathType" .) }}
          pathType: Prefix
          {{- end }}
  tls:
  - hosts:
    - {{ $ingress.hostname | quote }}
    secretName: {{ printf "%s-tls" $ingress.hostname }}
---
{{- end -}}
{{- end -}}
