{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.deployment" -}}
{{- include "v1.workload.podController" . -}}
{{- end -}}