{{- /* vim: set filetype=mustache: */}}

{{- /*

*/}}
{{- define "v1.networking.ingress" -}}
{{ $context := . }}
{{- if eq (title .Values.exposureType) "Ingress" }}
{{- range $ingressName, $ingress := .Values.ingress }}
apiVersion: {{ include "v1.capabilities.ingress.apiVersion" $context }}
kind: Ingress
metadata:
  name: {{ $context.Release.Name }}-{{ $ingressName }}
  namespace: {{ $context.Release.Namespace }}
  labels: {{- include "v1.helper.meta.labels" (dict "context" $context "component" $ingressName) | nindent 4 }}
  annotations: {{ toYaml $ingress.annotations | nindent 4 }}
spec:
  rules:
    - host: {{ $ingress.hostname }}
      http:
        paths:
          - path: {{ $ingress.path | default "/" }}
            pathType: {{ $ingress.pathType | default "ImplementationSpecific" }}
            backend:
              {{- if true }}
              service:
                name: {{ $context.Release.Name }}-{{ $ingressName }}
                port:
                  number: 80
              {{- else -}}
              serviceName: {{ $context.Release.Name }}-{{ $ingressName }}
              servicePort: 80
              {{- end -}}
          {{- range $extraPath := $ingress.extraPaths -}}
          - path: {{ $extraPath.path }}
            pathType: {{ $extraPath.pathType | default "ImplementationSpecific" }}
              backend:
              {{- if true }}
              service:
                name: {{ $context.Release.Name }}-{{ $ingressName }}
                port:
                  number: 80
              {{- else -}}
              serviceName: {{ $context.Release.Name }}-{{ $ingressName }}
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
                name: {{ $context.Release.Name }}-{{ $ingressName }}
                port:
                  number: 80
              {{- else -}}
              serviceName: {{ $context.Release.Name }}-{{ $ingressName }}
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