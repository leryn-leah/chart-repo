{{- define "charts.deployment.strategy" -}}
{{/*
  Deployment Strategy
==============================
*/}}
strategy:
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 1
  type: RollingUpdate
{{- end -}}

---

{{- define "charts.deployment.base.container.image" -}}
{{/*
  Deployment Images
==============================
*/}}
image: {{ .image.name }}:{{ .image.tag | default "latest" }}
imagePullPolicy: {{ .image.imagePullPolicy | default "Always" }}
{{- end -}}

---

{{- define "charts.deployment.base.container.environment" -}}
{{/*
  Deployment Environment
==============================
*/}}
{{- include "charts.deployment.base.container.environmentSingle" . }}
{{- include "charts.deployment.base.container.environmentFrom" . }}
{{- end -}}

---

{{- define "charts.deployment.base.container.environmentSingle" -}}
{{/*
  Deployment Environment
==============================
*/}}
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

{{- define "charts.deployment.base.container.environmentFrom" -}}
{{- if .secrets }}
envFrom:
  {{- range $secret := .secrets }}
  - secretRef:
      name: {{ $secret }}
  {{- end }}
{{- end -}}
{{- end -}}

---

{{- define "charts.deployment.base.container.port" -}}
{{/*
  Deployment Container Ports
==============================
*/}}
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

{{- define "charts.deployment.base.container.resource" -}}
{{/*
  Deployment Resource
==============================
*/}}
resources:
  limits:
    cpu: 1000m
    memory: 512Mi
  requests:
    cpu: 50m
    memory: 256Mi
{{- end -}}

---

{{- define "charts.deployment.base.container.volume" -}}
{{/*
  Deployment Volume
==============================
*/}}
  volumeMounts:
  - mountPath: /opt/config/
    name: leryn-cloud-api-gateway-config-cmv
    readOnly: true
    subPath: .
volumes:
- configMap:
    defaultMode: 420
    name: leryn-cloud-api-gateway-config-cm
  name: leryn-cloud-api-gateway-config-cmv
{{- end -}}