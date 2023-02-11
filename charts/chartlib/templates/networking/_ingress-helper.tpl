{{- /* vim: set filetype=mustache: */}}

{{- define "v1.networking.ingress.spec" -}}
  defaultBackend: ""
  ingressClassName: {{ .className }}
{{- end -}}

{{- define "v1.networking.ingress.backend" -}}
{{- end -}}

{{- define "v1.networking.ingress.rule" -}}
host: ""
  paths:
  - path: ""
    pathType: Prefix
    backend:
      service: ""
      port:
        number: 8080
{{- end }}

{{- define "v1.networking.ingress.tls" -}}
{{- end -}}
