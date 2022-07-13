{{/*
  Deployment
==============================
*/}}
{{- define "charts.core.deployment" -}}
{{- range $deployName, $deploy := .Values.application }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ printf "%s-%s" $.Release.Name $deployName }}
  namespace: {{ include "charts.core.namespace.name" $ }}
  labels:
    app.kubernetes.io/name: {{ $.Release.Name }}
    app.kubernetes.io/instance: {{ printf "%s-%s" $.Release.Name $deployName }}
    app.kubernetes.io/component: {{ $deployName }}
spec:
  replicas: {{ default 3 $deploy.replicas }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ $.Release.Name }}
      app.kubernetes.io/instance: {{ printf "%s-%s" $.Release.Name $deployName }}
      app.kubernetes.io/component: {{ $deployName }}
  {{- include "charts.deployment.strategy" $ | indent 2 }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ $.Release.Name }}
        app.kubernetes.io/instance: {{ printf "%s-%s" $.Release.Name $deployName }}
        app.kubernetes.io/component: {{ $deployName }}
    spec:
      affinity: {}
      containers:
      -
        name: {{ $deployName }}
        {{- include "charts.deployment.base.container.image"       . | indent 8 }}
        {{- include "charts.deployment.base.container.environment" . | indent 8 }}
        {{- include "charts.deployment.base.container.port"        . | indent 8 }}
        {{- include "charts.deployment.base.container.resource"    . | indent 8 }}
        {{- include "charts.deployment.base.container.volume"      . | indent 6 }}

---
{{- end -}}
{{- end -}}