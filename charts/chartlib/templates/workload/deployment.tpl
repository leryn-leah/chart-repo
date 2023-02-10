{{- /* vim: set filetype=mustache: */}}

{{- include "api.workload.deployment" . -}}

{{- define "api.workload.deployment.meta" -}}
apiVersion: app/v1
kind: Deployment
metadata:
{{- end -}}

{{- define "api.workload.deployment" -}}
{{ $root := . }}
{{ $app := .Values.components.portal }}
{{ $appName := "portal" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $root.Release.Name }}-{{ $appName }}
  namespace: {{ $root.Release.Namespace }}
spec:
  replicas: {{ include "api.workload.application.replicas" $app }}
  selector:
    matchLabels: {}
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels: {}
    spec:
      automountServiceAccountToken: false
      initContainers:
      containers:
        -
          name: {{ $appName }}
          {{- include "api.workload.application.image" $app | nindent 10 }}
          {{- include "api.workload.application.command" $app | nindent 10 }}
          {{- include "api.workload.application.args" $app | nindent 10 }}
          {{- include "api.workload.application.ports" $app | nindent 10 }}
          {{- include "api.workload.application.env" $app | nindent 10 }}
          {{- include "api.workload.application.resources" $app | nindent 10 }}
          {{- include "api.workload.application.healthcheck" $app | nindent 10 }}
          {{- include "api.workload.application.volumeMounts" $app | nindent 10 }}
      {{- include "api.workload.application.volumes" $app | nindent 6 }}
      {{- include "api.workload.application.securityContext" $app | nindent 6 }}
{{- end -}}