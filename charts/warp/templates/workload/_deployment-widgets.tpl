{{/*
  Deployment Strategy
==============================
*/}}
{{- define "internal.workload.deployment.strategy" -}}
strategy:
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 1
  type: RollingUpdate
{{- end -}}

---

{{/*
  Deployment Images
==============================
*/}}
{{- define "internal.workload.container.base.image" -}}
image: {{ .image.name }}:{{ .image.tag | default "latest" }}
imagePullPolicy: {{ .image.imagePullPolicy | default "Always" }}
{{- end -}}

---

{{/*
  Deployment Environment
==============================
*/}}
{{- define "internal.workload.container.base.environment" -}}
{{- include "internal.workload.container.base.environmentSingle" . }}
{{- include "internal.workload.container.base.environmentFrom" . }}
{{- end -}}

---

{{/*
  Deployment Environment
==============================
Handle environment variables in form of key-value separately.
*/}}
{{- define "internal.workload.container.base.environmentSingle" -}}
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
- name: APP_NAME
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: spec.serviceAccountName
{{- end -}}

---

{{/*
  Deployment Environment
==============================
Handle environment variables in form of key-value from configmaps, secrets.
*/}}
{{- define "internal.workload.container.base.environmentFrom" -}}
{{- if .secrets }}
envFrom:
{{- range $secret := .secrets }}
- secretRef:
    name: {{ $secret }}
{{- end -}}
{{- end -}}
{{- end -}}

---

{{/*
  Deployment Container Ports
==============================
*/}}
{{- define "internal.workload.container.base.port" -}}
{{- if .ports }}
ports:
{{- range $port := .ports }}
- containerPort: {{ $port.port }}
  name: {{ $port.name | default ( printf "port-%d" ($port.port | int) ) }}
  protocol: {{ $port.protocol | default "TCP" }}
{{- end -}}
{{- end -}}
{{- end -}}

---

{{/*
  Deployment Resource
==============================
*/}}
{{- define "internal.workload.container.base.resource" -}}
resources:
  limits:
    cpu: 1000m
    memory: 512Mi
  requests:
    cpu: 50m
    memory: 256Mi
{{- end -}}

---

{{/*
  Deployment Volume
==============================
*/}}
{{- define "internal.workload.container.base.volume.mount" -}}
{{- if (coalesce .configMaps .persistences ) -}}
volumeMounts:
{{- range $configMap := .configMaps }}
{{- $configMapName := $configMap.name | replace "." "-" }}
- name: {{ $configMapName }}-cmv
  mountPath: {{ $configMap.path }}
  readOnly: true
  subPath: .
{{- end -}}
{{- range $persistence := .persistences }}
- name: {{ $persistence.name }}-pv
  mountPath: {{ $persistence.path }}
  readOnly: {{ $persistence.readOnly | default true }}
  subPath: {{ $persistence.subPath | default "." }}
{{- end -}}
{{- end -}}
{{- end -}}

---

{{/*
  Deployment Volume
==============================
*/}}
{{- define "internal.workload.deployment.volume" -}}
{{- if (coalesce .configMaps .persistences ) -}}
volumes:
{{- range $configMap := .configMaps }}
{{- $configMapName := $configMap.name | replace "." "-" }}
- configMap:
    defaultMode: 420
    name: {{ $configMapName }}-cm
  name: {{ $configMapName }}-cmv
{{- end -}}
{{- range $persistence := .persistences }}
- name: {{ $persistence.name }}-pv
  persistentVolumeClaim:
    claimName: {{ $persistence.name }}-pvc
{{- end -}}
{{- end -}}
{{- end -}}

---

{{- define "internal.deployment.base.affinity" -}}
{{ .deploy }}
{{/**
{{- if .affinity }}
affinity: {{ .affinity }}
{{- else }}
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          topologyKey: kubernetes.io/hostname
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - {{ $.Release.Name }}
              - key: app.kubernetes.io/instance
                operator: In
                values:
                  - {{ printf "%s-%s" $.Release.Name .deployName }}
              - key: app.kubernetes.io/component
                operator: In
                values:
                  - {{ .deployName }}
*/}}
{{- end -}}