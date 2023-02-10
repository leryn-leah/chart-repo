{{- /* vim: set filetype=mustache: */}}

{{/*
Renders a value that contains template.
Usage:
{{ include "_.tplvalues.render" ( dict "value" .Values.path.to.the.Value "ctx" $) }}
*/}}
{{- define "_.tplvalues.render" -}}
  {{- if typeIs "string" .value }}
    {{- tpl .value .ctx }}
  {{- else }}
    {{- tpl (.value | toYaml) .ctx }}
  {{- end }}
{{- end -}}