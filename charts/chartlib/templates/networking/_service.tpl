{{- /* vim: set filetype=mustache: */}}

{{- define "v1.networking.service" -}}
{{- $root := . -}}
{{- range $serviceName, $service := .Values.service -}}
{{- /*{{- if $service.enabled }}*/}}
apiVersion: v1
kind: Service
metadata:
  name: kreutzer-vault
  namespace: kreutzer
  labels:
    "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
    "app.kubernetes.io/component": {{ quote $serviceName }}
  annotations: {}
spec:
  type: ClusterIP
{{- /*  {{- $ipv4Enabled := ternary $root.ipFamily.ipv4 $root.ipFamily.ipv4 $root.ipFamily.ipv4.enabled -}}*/}}
{{- /*  {{- $ipv6Enabled := ternary $root.ipFamily.ipv6 $root.ipFamily.ipv6 $root.ipFamily.ipv6.enabled -}}*/}}
{{- /*  {{- if and $ipv4Enabled $ipv6Enabled -}}*/}}
{{- /*  ipFamilies:*/}}
{{- /*  {{- if ternary $root.ipFamily.ipv4 $root.ipFamily.ipv4 $root.ipFamily.ipv4.enabled -}}*/}}
{{- /*  - IPv4*/}}
{{- /*  {{- end -}}*/}}
{{- /*  {{- if ternary $root.ipFamily.ipv6 $root.ipFamily.ipv6 $root.ipFamily.ipv6.enabled -}}*/}}
{{- /*  - IPv6*/}}
{{- /*  {{- end -}}*/}}
{{- /*  {{- end -}}*/}}
  {{- if .ports }}
  ports:
    {{- if .ports.http }}
    - name: http
      port: 80
      targetPort: {{ .ports.http }}
      protocol: TCP
    {{- end -}}
    {{- if .ports.https }}
    - name: https
      port: {{ .ports.https }}
      targetPort: 443
      protocol: TCP
    {{- end -}}
    {{- if .ports.tcp }}
    {{- range $portName, $port := .ports.tcp }}
    - name: {{ $portName }}
      port: {{ $port }}
      targetPort: {{ $port }}
      protocol: TCP
    {{- end -}}
    {{- end -}}
    {{- if .ports.udp }}
    {{- range $portName, $port := .ports.udp }}
    - name: {{ $portName }}
      port: {{ $port }}
      targetPort: {{ $port }}
      protocol: UDP
    {{- end -}}
    {{- end -}}
    {{- if .ports.sctp }}
    {{- range $portName, $port := .ports.sctp }}
    - name: {{ $portName }}
      port: {{ $port }}
      targetPort: {{ $port }}
      protocol: SCTP
    {{- end -}}
    {{- end -}}
  {{- end }}
  selector:
    "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
    "app.kubernetes.io/component": {{ quote $serviceName }}
---
{{- end -}}
{{- end -}}
