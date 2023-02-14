{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.daemonset" -}}
{{- include "v1.workload.podController" . -}}
{{- end -}}