{{- /* vim: set filetype=mustache: */}}

{{- if eq .Values.exposureType "ingress" -}}
{{- include "api.networking.ingress" . -}}
{{- end -}}

{{- /*

*/}}
{{- define "api.networking.ingress" -}}
{{ $root := . }}
{{- /*{{ $someIngress := (include "_.tplvalues.render" ( dict "value" .Values.ingress "ctx" $ "root" $root)) | fromYaml }}*/}}
{{- /*{{ range $ingressName, $ingress := $someIngress }}*/}}
{{ $ingress := .Values.ingress.core }}
{{ $ingressName := "core" }}
apiVersion: {{ include "api.capabilities.ingress.apiVersion" $ }}
kind: Ingress
metadata:
  name: {{ $root.Release.Name }}-{{ $ingressName }}
  namespace: {{ $root.Release.Namespace }}
  annotations:
    {{- if $root.commonAnnotations }}
    {{- $root.commonAnnotations | toYaml | nindent 4 }}
    {{- end }}
    {{- if $ingress.annotations }}
    {{- $ingress.annotations | toYaml | nindent 4 }}
    {{- end }}
  labels:
    {{- if $root.commonLabels }}
    {{- $root.commonLabels | toYaml | nindent 4 }}
    {{- end }}
spec:
  {{- include "api.networking.ingress.ingressclass" $ingress | nindent 2 -}}
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


{{- /*
  - In: .Values.Ingress.<Application>
*/}}
{{- define "api.networking.ingress.ingressclass" -}}
{{- if .className }}
ingressClassName: {{ .className }}
{{- end }}
{{- end -}}