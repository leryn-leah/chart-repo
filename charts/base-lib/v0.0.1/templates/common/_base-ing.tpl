{{- define "charts.base.ingress" -}}
{{- $unitName := .Release.Name -}}
{{- range $channelName, $channel := .Values.channels -}}
{{- range $ingressName, $ingress := $channel.ingress -}}
{{- $service := $ingress.service -}}
{{- $attr := $ingress.attributes -}}
{{/*
  Ingress
*/}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $unitName }}-{{ $channelName }}-{{ $ingressName }}-ing
  labels:
    app.kubernetes.io/name: {{ $unitName }}
    app.kubernetes.io/instance: {{ $unitName }}-{{ $channelName }}-{{ $ingressName }}
  annotations:
    kubernetes.io/ingress.class: {{ $attr.ingressClass }}
    nginx.ingress.kubernetes.io/ssl-redirect: {{ $attr.sslRedirect | default true | quote }}
    {{- if $attr.enableCors | default false }}
    nginx.ingress.kubernetes.io/enable-cors: {{ default true }}
    nginx.ingress.kubernetes.io/cors-allow-methods: {{ quote $attr.corsAllowMethods }}
    nginx.ingress.kubernetes.io/cors-allow-origin: {{ quote $attr.corsAllowOrigin }}
    {{- end }}
    {{- if $attr.rewriteTarget }}
    nginx.ingress.kubernetes.io/rewrite-target: {{ $attr.rewriteTarget }}
    {{- end }}
    {{- range $annoKey, $annoValue := $ingress.annotations }}
    {{ $annoKey }}: {{ quote $annoValue }}
    {{- end }}
spec:
  rules:
    - host: {{ $ingress.host }}
      http:
        paths:
          {{- range $path := $ingress.paths }}
          - path: {{ $path.path }}
            pathType: ImplementationSpecific
            backend:
              service:
                name: {{ $unitName }}-{{ $channelName }}-{{ $path.service.name }}-svc
                port:
                  number: {{ $path.service.port | default 80 }}
          {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}