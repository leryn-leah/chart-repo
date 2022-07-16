{{/*
  Service
==============================
Rendored when exposure type is ingress.
*/}}
{{- define "api.network.service" -}}
{{- if .Values.exposure.enabled -}}
{{- if eq "ingress" .Values.exposure.type -}}
{{- range $serviceName, $service := .Values.application }}
apiVersion: v1
kind: Service
metadata:
  name: {{ $serviceName }}
  namespace: {{ include "api.namespace.name" $ }}
  labels:
    app.kubernetes.io/name: {{ $.Release.Name }}
    app.kubernetes.io/instance: {{ $serviceName }}
    app.kubernetes.io/component: {{ $serviceName }}
spec:
  type: ClusterIP
  ports:
    {{- range $portName, $port := .ports }}
    - name: {{ $port.name | default ( printf "port-%d" ($port.port | int) ) }}
      port: {{ $port.servicePort | default 80 }}
      targetPort: {{ $port.port }}
      protocol: {{ $port.protocol | default "TCP" }}
    {{- end }}
  selector:
    app.kubernetes.io/name: {{ $.Release.Name }}
    app.kubernetes.io/instance: {{ $serviceName }}
    app.kubernetes.io/component: {{ $serviceName }}
---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
