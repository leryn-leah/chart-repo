{{- /* vim: set filetype=mustache: */}}

{{- define "api.networking.ingress.spec" -}}
  defaultBackend: ""
  ingressClassName: {{ .className }}
{{- end -}}

{{- define "api.networking.ingress.backend" -}}
{{- end -}}

{{- define "api.networking.ingress.rule" -}}
host: ""
  paths:
  - path: ""
    pathType: Prefix
    backend:
      service: ""
      port:
        number: 8080
{{- end }}

{{- define "api.networking.ingress.tls" -}}
{{- end -}}
