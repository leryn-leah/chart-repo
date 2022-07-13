{{/*
  Service
==============================
*/}}
{{- define "charts.core.service" -}}
{{- range $serviceName, $service := .Values.application }}
apiVersion: v1
kind: Service
metadata:
  name: {{ $serviceName }}
  namespace: {{ include "charts.core.namespace.name" $ }}
  labels:
    app.kubernetes.io/name: {{ $.Release.Name }}
    app.kubernetes.io/instance: {{ printf "%s-%s" $.Release.Name $serviceName }}
    app.kubernetes.io/component: {{ $serviceName }}
spec:
  type: ClusterIP
  ports:
    {{- range $port := .ports }}
    - name: {{ $port.name | default ( printf "port-%d" ($port.port | int) ) }}
      port: {{ $port.servicePort | default 80 }}
      targetPort: {{ $port.port }}
      protocol: {{ $port.protocol | default "TCP" }}
    {{- end }}
  selector:
    app.kubernetes.io/name: {{ $.Release.Name }}
    app.kubernetes.io/instance: {{ printf "%s-%s" $.Release.Name $serviceName }}
    app.kubernetes.io/component: {{ $serviceName }}
---
{{- end -}}
{{- end -}}
