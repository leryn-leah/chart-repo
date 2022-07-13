{{- define "charts.base.configMap" -}}
{{- $unitName := .Release.Name -}}
{{- range $channelName, $channel := .Values.channels -}}
{{- range $serviceName, $service := $channel.services -}}
{{- if default $channel.enable true -}}
{{- if $service.configMaps -}}
{{- range $configMap := $service.configMaps -}}
{{- $name := printf "%s-%s-%s-%s-cm" $unitName $channelName $serviceName $configMap.name -}}
{{/*
  Config Map
*/}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $name }}
  labels:
    app.kubernetes.io/name: {{ $unitName }}
    app.kubernetes.io/instance: {{ $name }}
data:
  {{ $configMap.filename }}: |-
  {{- if $configMap.values }}
    {{- $configMap.values | nindent 4 }}
  {{- else }}
    {{ .Files.Get $configMap.filename | nindent 4 }}
  {{- end }}

---
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}