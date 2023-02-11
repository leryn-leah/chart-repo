{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.daemonset" -}}
{{- $root := . -}}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled }}
{{- if eq (title $application.type) "DaemonSet" }}
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: {{ $root.Release.Name }}-{{ $applicationName }}
  namespace: {{ $root.Release.Namespace }}
  labels:
    "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
    "app.kubernetes.io/component": {{ quote $applicationName }}
  annotations: {}
spec:
  replicas: {{ include "v1.workload.application.replicas" $application }}
  selector:
    matchLabels: {}
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
          {{- include "v1.workload.application.container" $initContainer | nindent 10 }}
      {{- end }}
      {{- end }}
      containers:
        -
          name: {{ $applicationName }}
          {{- include "v1.workload.application.container" $application | nindent 10 }}

        {{- if $application.sidecars }}
        {{- range $sidecar := $application.sidecars }}
        -
          name: {{ $applicationName }}
          {{- include "v1.workload.application.container" $sidecar | nindent 10 }}
        {{- end }}
        {{- end }}
      {{- include "v1.workload.application.volumes" $application | nindent 6 }}
      {{- include "v1.workload.application.securityContext" $application | nindent 6 }}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}