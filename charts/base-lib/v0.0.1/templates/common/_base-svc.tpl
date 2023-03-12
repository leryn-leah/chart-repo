{{- define "charts.base.service" -}}
{{- $unitName := .Release.Name -}}
{{- range $channelName, $channel := .Values.channels -}}
{{- range $serviceName, $service := $channel.services -}}
{{- if default $channel.enable true -}}
{{/*
  Service
*/}}
apiVersion: v1
kind: Service
metadata:
  name: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}-svc
  labels:
    app.kubernetes.io/name: {{ $unitName }}
    app.kubernetes.io/instance: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}
spec:
  {{- if $service.nodePort }}
  type: NodePort
  ports:
    - name: port-{{ $service.container.port }}
      port: 80
      targetPort: {{ $service.container.port }}
      nodePort: {{ $service.nodePort }}
      protocol: TCP
  {{- else }}
  type: ClusterIP
  ports:
    - name: port-{{ $service.container.port }}
      port: 80
      targetPort: {{ $service.container.port }}
      protocol: TCP
  {{- end }}
  selector:
    app.kubernetes.io/name: {{ $unitName }}
    app.kubernetes.io/instance: {{ $unitName }}-{{ $channelName }}-{{ $serviceName }}

---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}