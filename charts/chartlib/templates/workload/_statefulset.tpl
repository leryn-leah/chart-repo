{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.statefulset" -}}
{{- include "v1.workload.podController" . -}}
{{- end -}}