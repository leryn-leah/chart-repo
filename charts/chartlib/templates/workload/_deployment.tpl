{{- /* vim: set filetype=mustache: */}}

{{- define "api.workload.deployment" -}}
{{- $root := . -}}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled -}}
{{- if eq (title $application.type) "Deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $root.Release.Name }}-{{ $applicationName }}
  namespace: {{ $root.Release.Namespace }}
  labels:
    "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
    "app.kubernetes.io/component": {{ quote $applicationName }}
  annotations: {}
spec:
  replicas: {{ include "api.workload.application.replicas" $application }}
  selector:
    matchLabels: {}
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
        "app.kubernetes.io/component": {{ quote $applicationName }}
      annotations: {}
    spec:
      automountServiceAccountToken: false
      restartPolicy: Always
      {{- if $application.initContainers }}
      initContainers:
      {{- range $initContainer := $application.initContainers }}
        -
          name: {{ $initContainer.name }}
          {{- include "api.workload.application.container" $initContainer | nindent 10 }}
      {{- end }}
      {{- end }}
      containers:
        -
          name: {{ $applicationName }}
          {{- include "api.workload.application.container" $application | nindent 10 }}
        {{- if $application.sidecars }}
        {{- range $sidecar := $application.sidecars }}
        -
          name: {{ $sidecar.name }}
          {{- include "api.workload.application.container" $sidecar | nindent 10 }}
        {{- end }}
        {{- end }}
      {{- include "api.workload.application.volumes" $application | nindent 6 }}
      {{- include "api.workload.application.securityContext" $application | nindent 6 }}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}