{{- /* vim: set filetype=mustache: */}}

{{- /*
  Container template
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.container" -}}
{{ include "api.workload.application.image" . }}
{{ include "api.workload.application.command" . }}
{{ include "api.workload.application.args" . }}
{{ include "api.workload.application.ports" . }}
{{ include "api.workload.application.env" . }}
{{ include "api.workload.application.resources" . }}
{{/*{{ include "api.workload.application.lifecycle" . }}*/}}
{{ include "api.workload.application.volumeMounts" . }}
{{- end -}}

{{- /*
  Number of Replicas
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.replicas" -}}
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
{{- define "api.workload.application.image" -}}
{{- $registry := default "docker.io" .image.registry }}
{{- $repository := required "The image is required!" .image.repository }}
{{- $tag := default .image.digest .image.tag "latest" }}
{{- if contains ":" $repository }}
image: {{ printf "%s/%s" $registry $repository }}
{{- else }}
image: {{ printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}
{{- if .pullPolicy }}
imagePullPolicy: {{ default "IfNotPresent" .pullPolicy }}
{{- end }}
{{- if .pullSecrets }}
imagePullSecrets: {{ .pullSecrets }}
{{- end -}}
{{- end -}}

{{- /*
  Container entrypoint
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.command" -}}
{{- if .command }}
command:
{{ range $commandSeg := .command }}
  - {{ quote $commandSeg }}
{{- end }}
{{- end }}
{{- end -}}

{{- /*
  Container arguments
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.args" -}}
{{- if .args }}
args:
{{ range $arg := .args }}
  - {{ quote $arg }}
{{- end }}
{{- end }}
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
{{- define "api.workload.application.ports" -}}
{{- if .ports }}
ports:
  {{- if .ports.http }}
  - name: http
    containerPort: {{ .ports.http }}
  {{- end -}}
  {{- if .ports.https }}
  - name: https
    containerPort: {{ .ports.https }}
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
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.env" -}}
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
envFrom: []
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.resources" -}}
{{- if .resources }}
resources:
  {{- .resources | toYaml | nindent 2 }}
{{- end }}
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
{{- define "api.workload.application.volumeMounts" -}}
volumeMounts:
{{- if .configMaps }}
{{- range $configMapName, $configMap := .configMaps }}
  - name: {{ $configMapName }}
    mountPath: {{ $configMap.mountPath }}
    subPath: {{ base $configMap.mountPath }}
{{- end }}
{{- end }}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.healthcheck" -}}

livenessProbe: {}
readinessProbe: {}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.lifecycle" -}}
{{- if .lifecycle }}
lifecycle:
  {{- .lifecycle | nindent 4 }}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.volumes" -}}
volumes: []
{{- end -}}

{{- /*
  - In: .Values.<Application>
*/}}
{{- define "api.workload.application.securityContext" -}}
securityContext: {}
{{- end -}}

