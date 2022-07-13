{{- define "charts.base.namepace" -}}
{{- if .Values.namespace.create -}}
{{- $name := coalesce .Values.namespace.name .Release.Name "default" -}}
{{/*
  Namespace
*/}}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ $name }}
  labels:
    kubernetes.io/metadata.name: {{ $name }}
---
{{- end -}}
{{- end -}}