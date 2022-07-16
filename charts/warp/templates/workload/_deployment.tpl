{{/*
  Deployment
==============================
*/}}
{{- define "api.workload.deployment" -}}
{{- range $deployName, $deploy := .Values.application }}
{{- if eq "normal" ($deploy.language | default "normal" ) -}}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $deployName }}
  namespace: {{ include "api.namespace.name" $ }}
  labels:
    app.kubernetes.io/name: {{ $.Release.Name }}
    app.kubernetes.io/instance: {{ $deployName }}
    app.kubernetes.io/component: {{ $deployName }}
spec:
  replicas: {{ $deploy.replicas | default 3 }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ $.Release.Name }}
      app.kubernetes.io/instance: {{ $deployName }}
      app.kubernetes.io/component: {{ $deployName }}
  {{- include "internal.workload.deployment.strategy" $ | nindent 2 }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ $.Release.Name }}
        app.kubernetes.io/instance: {{ $deployName }}
        app.kubernetes.io/component: {{ $deployName }}
    spec:
      
      containers:
      -
        name: {{ $deployName }}
        {{- include "internal.workload.container.base.image"        . | nindent 8 }}
        {{- include "internal.workload.container.base.environment"  . | nindent 8 }}
        {{- include "internal.workload.container.base.port"         . | nindent 8 }}
        {{- include "internal.workload.container.base.resource"     . | nindent 8 }}
        {{- include "internal.workload.container.base.volume.mount" . | nindent 8 }}
        
      {{- include "internal.workload.deployment.volume"  . | nindent 6 }}
---
{{- end -}}
{{- end -}}
{{- end -}}