{{- /* vim: set filetype=mustache: */}}

{{- define "v1.config.secret" -}}
{{- include "v1.config.secret.opaque" . -}}
{{- end -}}

{{- define "v1.config.secret.opaque" -}}
{{- $root := . -}}
{{- $operator := . -}}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled }}
{{- range $secretName, $secret := $application.secrets }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
  namespace: {{ $root.Release.Namespace }}
  labels:
    "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
    "app.kubernetes.io/component": {{ quote $applicationName }}
  annotations: {}
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
{{/*  annotations: {}*/}}
{{/*  labels: {}*/}}
{{/*type: Opaque*/}}
{{/*stringData: {}*/}}
{{/*{{- end -}}*/}}

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