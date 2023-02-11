{{- /* vim: set filetype=mustache: */}}

{{- /*

*/}}
{{- define "v1.networking.ingress" -}}
{{ $root := . }}
{{- if eq (title .Values.exposureType) "Ingress" }}
{{- range $ingressName, $ingress := .Values.ingress }}
apiVersion: {{ include "v1.capabilities.ingress.apiVersion" $root }}
kind: Ingress
metadata:
  name: {{ $root.Release.Name }}-{{ $ingressName }}
  namespace: {{ $root.Release.Namespace }}
  labels:
    "app.kubernetes.io/name": {{ $root.Chart.Name }}
    "app.kubernetes.io/component": {{ $ingressName }}
  annotations: {}
spec:
{{/*  {{- include "v1.networking.ingress.ingressclass" $ingress | nindent 2 -}}*/}}
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
{{- define "v1.networking.ingress.ingressclass" -}}
{{- if .className }}
ingressClassName: {{ .className }}
{{- end -}}
{{- end -}}