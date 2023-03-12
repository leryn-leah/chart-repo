{{- /* vim: set filetype=mustache: */}}

{{- define "v1.helper.meta.labels" -}}
"app.kubernetes.io/name": {{ quote .context.Chart.Name }}
"app.kubernetes.io/instance": {{ quote .context.Release.Name }}
"app.kubernetes.io/component": {{ quote .component }}
{{- if .context.Values.commonLabels }}
{{ .context.Values.commonLabels | toYaml }}
{{- end }}
{{- end -}}

{{- define "v1.helper.meta.annotations" -}}
{{- if .context.Values.commonAnnotations }}
{{ .context.Values.commonAnnotations | toYaml }}
{{- else }}
{}
{{- end }}
{{- end -}}