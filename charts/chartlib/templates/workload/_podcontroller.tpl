{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.podController" -}}
{{- $context := . }}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled -}}
{{- $type := title (default "Deployment" $application.type) -}}
{{- if has $type (list "Deployment" "StatefulSet" "DaemonSet") }}
apiVersion: apps/v1
kind: {{ $type }}
metadata:
  name: {{ $context.Release.Name }}-{{ $applicationName }}
  namespace: {{ $context.Release.Namespace }}
  labels: {{- include "v1.helper.meta.labels" (dict "context" $context "component" $applicationName) | nindent 4 }}
  annotations: {{- include "v1.helper.meta.annotations" (dict "context" $context "component" $applicationName) | nindent 4 }}
spec:
  {{- if eq $type "StatefulSet" }}
  serviceName: {{ $context.Release.Name }}-{{ $applicationName }}
  {{- end }}
  {{- if has $type (list "StatefulSet" "DaemonSet") }}
  updateStrategy:
    type: RollingUpdate
  {{- end }}
  replicas: {{ include "v1.workload.application.replicas" $application }}
  selector:
    matchLabels: {{- include "v1.helper.meta.labels" (dict "context" $context "component" $applicationName) | nindent 6 }}
  template:
    metadata:
      labels: {{- include "v1.helper.meta.labels" (dict "context" $context "component" $applicationName) | nindent 8 }}
      annotations: {{- include "v1.helper.meta.annotations" (dict "context" $context "component" $applicationName) | nindent 8 }}
    spec:
      automountServiceAccountToken: false
      restartPolicy: Always
      {{- if or $application.initContainers $application.predefinedInitContainers }}
      initContainers:
      {{- range $initContainer := $application.initContainers }}
        -
          name: {{ $initContainer.name }}
          {{- include "v1.workload.application.container" (omit $initContainer "securityContext" "volumes" "initContainers" "sidecars" "predefinedInitContainers" "predefinedSidecars") | nindent 10 }}
      {{- end }}
      {{- range $initContainer := $application.predefinedInitContainers }}
        -
          name: {{ $initContainer.name }}
          {{- include "v1.workload.predefinedInitContainer.container" $initContainer | nindent 10 }}
      {{- end }}
      {{- end }}
      containers:
        -
          name: {{ $applicationName }}
          {{- include "v1.workload.application.container" $application | nindent 10 }}
        {{- if $application.sidecars }}
        {{- range $sidecar := $application.sidecars }}
        -
          name: {{ $sidecar.name }}
          {{- include "v1.workload.application.container" (omit $sidecar "securityContext" "volumes" "initContainers" "sidecars" "predefinedInitContainers" "predefinedSidecars") | nindent 10 }}
        {{- end }}
        {{- end }}
        {{- range $sidecar := $application.predefinedSidecars }}
        -
          name: {{ $sidecar.name }}
          {{- include "v1.workload.predefinedSidecar.container" $sidecar | nindent 10 }}
        {{- end }}
      {{- include "v1.workload.application.podSecurityContext" $application | nindent 6 }}
      {{- include "v1.workload.application.volumes" $application | nindent 6 }}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
