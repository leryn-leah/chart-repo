{{- /* vim: set filetype=mustache: */}}

{{- /*

*/}}
{{- define "api.networking.ingress" -}}
{{ $root := . }}
{{- if eq (title .Values.exposureType) "Ingress" }}
{{- range $ingressName, $ingress := .Values.ingress }}
apiVersion: {{ include "api.capabilities.ingress.apiVersion" $root }}
kind: Ingress
metadata:
  name: {{ $root.Release.Name }}-{{ $ingressName }}
  namespace: {{ $root.Release.Namespace }}
  labels:
    "app.kubernetes.io/name": {{ $root.Chart.Name }}
    "app.kubernetes.io/component": {{ $ingressName }}
  annotations: {}
spec:
{{/*  {{- include "api.networking.ingress.ingressclass" $ingress | nindent 2 -}}*/}}
  rules:
    - host: core.domain.com
      http:
        paths:
          - path: /
            pathType: ImplementationSpecific
            backend:
              service:
                name: {{ $root.Release.Name }}-{{ $ingressName }}
                port:
                  number: 8080
  {{- if $ingress.tls }}
  tls:
    - hosts:
      - core.domain.com
      secretName: ""
  {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.Ingress.<Application>
*/}}
{{- define "api.networking.ingress.ingressclass" -}}
{{- if .className }}
ingressClassName: {{ .className }}
{{- end -}}
{{- end -}}