{{- define "charts.core.namespace.name" -}}
{{- if .Values.namespace -}}
{{- if .Values.namespace.create -}}
{{- coalesce .Release.Namespace .Values.namespace.name "default" -}}
{{- else -}}
{{- coalesce .Release.Namespace "default" -}}
{{- end -}}
{{- else -}}
{{- coalesce .Release.Namespace "default" -}}
{{- end -}}
{{- end -}}
