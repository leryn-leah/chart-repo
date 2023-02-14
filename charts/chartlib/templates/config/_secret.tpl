{{- /* vim: set filetype=mustache: */}}

{{- define "v1.config.secret" -}}
{{- include "v1.config.secret.opaque" . -}}
{{- end -}}

{{- define "v1.config.secret.opaque" -}}
{{- $context := . -}}
{{- $operator := . -}}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled }}
{{- range $secretName, $secret := $application.secrets }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
  namespace: {{ $context.Release.Namespace }}
  labels: {{- include "v1.helper.meta.labels" (dict "context" $context "component" $applicationName) | nindent 4 }}
  annotations: {{- include "v1.helper.meta.annotations" (dict "context" $context "component" $applicationName) | nindent 4 }}
type: Opaque
stringData:
  {{- range $entryKey, $entryValue := $secret }}
  {{ $entryKey }}: {{ $entryValue }}
  {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*{{- if .Values.debug -}}*/}}
{{/*---*/}}
{{/*apiVersion: v1*/}}
{{/*kind: Secret*/}}
{{/*metadata:*/}}
{{/*  name: ""*/}}
{{/*  namespace: ""*/}}
{{/*type: kubernetes.io/tls*/}}
{{/*data:*/}}
{{/*  tls.key: ""*/}}
{{/*  tls.crt: ""*/}}
{{/*{{- end -}}*/}}