{{- /* vim: set filetype=mustache: */}}

{{- define "v1.workload.podController" -}}
{{- $context := . }}
{{- range $applicationName, $application := .Values.components -}}
{{- if $application.enabled -}}
{{- $type := title $application.type -}}
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
      {{- if $application.initContainers }}
      initContainers:
      {{- range $initContainer := $application.initContainers }}
        -
          name: {{ $initContainer.name }}
          {{- include "v1.workload.application.container" (omit $initContainer "securityContext" "volumes" "initContainers" "sidecars")  | nindent 10 }}
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
          {{- include "v1.workload.application.container" (omit $sidecar "securityContext" "volumes" "initContainers" "sidecars")  | nindent 10 }}
        {{- end }}
        {{- end }}
      {{- include "v1.workload.application.podSecurityContext" $application | nindent 6 }}
      {{- include "v1.workload.application.volumes" $application | nindent 6 }}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  Container template
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.container" -}}
{{ include "v1.workload.application.image" . }}
{{ include "v1.workload.application.command" . }}
{{ include "v1.workload.application.args" . }}
{{ include "v1.workload.application.ports" . }}
{{ include "v1.workload.application.env" . }}
{{ include "v1.workload.application.resources" . }}
{{ include "v1.workload.application.lifecycle" . }}
{{ include "v1.workload.application.securityContext" . }}
{{ include "v1.workload.application.volumeMounts" . }}
{{- end -}}

{{- /*
  Number of Replicas
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.replicas" -}}
{{- if eq (toString .replicas) "0" }}
{{- .replicas }}
{{- else }}
{{- (default 1 .replicas) }}
{{- end }}
{{- end -}}

{{- /*
  Container image
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.image" -}}
{{- $registry := default "docker.io" .image.registry -}}
{{- $repository := required "The image is required!" .image.repository -}}
{{- $tag := default .image.digest .image.tag "latest" -}}
{{- if contains ":" $repository -}}
image: {{ printf "%s/%s" $registry $repository }}
{{- else -}}
image: {{ printf "%s/%s:%s" $registry $repository $tag }}
{{- end -}}
{{- if .pullPolicy }}
imagePullPolicy: {{ default "IfNotPresent" .pullPolicy }}
{{- end -}}
{{- if .pullSecrets -}}
imagePullSecrets: {{ .pullSecrets }}
{{- end -}}
{{- end -}}

{{- /*
  Container entrypoint
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.command" -}}
{{- if .command -}}
command:
{{- range $command := .command }}
  - {{ quote $command }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  Container arguments
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.args" -}}
{{- if .args -}}
args:
{{- range $arg := .args }}
  - {{ quote $arg }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  Container ports
  ```
  ports:
    http: 80
    https: 443
    tcp:
      rpc: 8080
    udp:
      NTP: 123
  ```
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.ports" -}}
{{- if .ports -}}
ports:
  {{- if .ports.http }}
  - name: http
    containerPort: {{ .ports.http }}
    protocol: TCP
  {{- end -}}
  {{- if .ports.https }}
  - name: https
    containerPort: {{ .ports.https }}
    protocol: TCP
  {{- end -}}
  {{- if .ports.tcp }}
  {{- range $portName, $port := .ports.tcp }}
  - name: {{ $portName }}
    containerPort: {{ $port }}
    protocol: TCP
  {{- end -}}
  {{- end -}}
  {{- if .ports.udp }}
  {{- range $portName, $port := .ports.udp }}
  - name: {{ $portName }}
    containerPort: {{ $port }}
    protocol: UDP
  {{- end -}}
  {{- end -}}
  {{- if .ports.sctp }}
  {{- range $portName, $port := .ports.sctp }}
  - name: {{ $portName }}
    containerPort: {{ $port }}
    protocol: SCTP
  {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.env" -}}
env:
  - name: TZ
    value: Asia/Shanghai
  - name: NODE_NAME
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: spec.nodeName
  - name: POD_NAME
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.name
  {{- if .env }}
  {{ .env | toYaml | nindent 2 }}
  {{- end }}
{{- if .secrets }}
envFrom:
  {{- if .secrets -}}
  {{- range $secretName, $secret := .secrets }}
  - secretRef:
      name: {{ $secretName }}
  {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.resources" -}}
{{- if .resources -}}
resources:
  {{- .resources | toYaml | nindent 2 }}
{{- else -}}
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 50m
    memory: 128Mi
{{- end -}}
{{- end -}}

{{- /*
  ```
  configMaps:
    <ConfigMap>:
      type: File
      projectPath: /path/to/conf/in/chart
      mountPath: /path/to/mount
  ```
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.volumeMounts" -}}
{{- $volumeMountsEnabled := or (not (empty .volumeMounts)) (not (empty .configMaps)) -}}
{{- if $volumeMountsEnabled -}}
volumeMounts:
  {{- if .volumeMounts -}}
  {{- .volumeMounts | toYaml | nindent 2 }}
  {{- end -}}
  {{- if .configMaps -}}
  {{- range $configMapName, $configMap := .configMaps }}
  - name: {{ $configMapName }}
    mountPath: {{ $configMap.mountPath }}
    subPath: {{ base $configMap.mountPath }}
  {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.healthcheck" -}}
livenessProbe: {}
readinessProbe: {}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.lifecycle" -}}
{{- if .lifecycle -}}
lifecycle:
  {{- .lifecycle | toYaml | nindent 2 }}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.volumes" -}}
{{- $volumesEnabled := or (not (empty .volumes)) (not (empty .configMaps)) }}
{{- if $volumesEnabled -}}
volumes:
  {{- if .volumeMounts -}}
  {{- .volumes | toYaml | nindent 2 }}
  {{- end -}}
  {{- if .configMaps -}}
  {{- range $configMapName, $configMap := .configMaps }}
  - name: {{ $configMapName }}
    configMap:
      name: {{ $configMapName }}
      defaultMode: 420
  {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.securityContext" -}}
{{- if .securityContext -}}
securityContext:
  {{- .securityContext | toYaml | nindent 2 }}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "v1.workload.application.podSecurityContext" -}}
{{- if .podSecurityContext -}}
securityContext:
  {{- .podSecurityContext | toYaml | nindent 2 }}
{{- end -}}
{{- end -}}
