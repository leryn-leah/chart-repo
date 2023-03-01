{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.predefinedSidecar.container" -}}
{{- if required "Predefined init container type required." .type }}
{{- $template := printf "v1.workload.sidecar.%s" .type -}}
{{- include $template . }}
{{- end -}}
{{- end -}}

{{- define "v1.workload.predefinedInitContainer.container" -}}
{{- if required "Predefined init container type required." .type }}
{{- $template := printf "v1.workload.sidecar.%s" .type -}}
{{- include $template . }}
{{- end -}}
{{- end -}}
