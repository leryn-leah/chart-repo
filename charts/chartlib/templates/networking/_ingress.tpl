{{- /* vim: set filetype=mustache: */}}

{{- /*

*/}}
{{- define "v1.networking.ingress" -}}
{{ $root := . }}
{{- if eq (title .Values.exposureType) "Ingress" }}
{{- range $ingressName, $ingress := .Values.ingress }}
apiVersion: {{ include "v1.capabilities.ingress.apiVersion" $root }}
kind: Ingress
metadata:
  name: {{ $root.Release.Name }}-{{ $ingressName }}
  namespace: {{ $root.Release.Namespace }}
  labels:
    "app.kubernetes.io/name": {{ quote $root.Chart.Name }}
    "app.kubernetes.io/component": {{ quote $ingressName }}
  annotations: {{ toYaml $ingress.annotations | nindent 4 }}
spec:
  rules:
    - host: {{ $ingress.hostname }}
      http:
        paths:
          - path: {{ $ingress.path }}
            pathType: {{ $ingress.pathType | default "ImplementationSpecific" }}
            backend:
              {{- if true }}
              service:
                name: {{ $root.Release.Name }}-{{ $ingressName }}
                port:
                  number: 80
              {{- else -}}
              serviceName: {{ $root.Release.Name }}-{{ $ingressName }}
              servicePort: 80
              {{- end -}}
          {{- range $extraPath := $ingress.extraPaths -}}
          - path: {{ $extraPath.path }}
            pathType: {{ $extraPath.pathType | default "ImplementationSpecific" }}
              backend:
              {{- if true }}
              service:
                name: {{ $root.Release.Name }}-{{ $ingressName }}
                port:
                  number: 80
              {{- else -}}
              serviceName: {{ $root.Release.Name }}-{{ $ingressName }}
              servicePort: 80
              {{- end -}}
          {{- end -}}
    {{- if $ingress.extraHosts -}}
    {{- range $extraHost := $ingress.extraHosts -}}
    - host: {{ $extraHost.name }}
      http:
        paths:
          - path: {{ $extraHost.path }}
            pathType: {{ $extraHost.pathType | default "ImplementationSpecific" }}
              backend:
              {{- if true }}
              service:
                name: {{ $root.Release.Name }}-{{ $ingressName }}
                port:
                  number: 80
              {{- else -}}
              serviceName: {{ $root.Release.Name }}-{{ $ingressName }}
              servicePort: 80
              {{- end -}}
    {{- end -}}
    {{- end -}}
  {{- if $ingress.tls }}
  tls:
    - hosts:
      - {{ $ingress.hostname }}
      secretName: ""
  {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
  - In: .Values.Ingress.<Application>
*/}}
{{- define "v1.networking.ingress.ingressclass" -}}
{{- if .className }}
ingressClassName: {{ .className }}
{{- end -}}
{{- end -}}