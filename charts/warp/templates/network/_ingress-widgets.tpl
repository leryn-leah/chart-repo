{{- define "internal.network.ingress.backend" -}}
{{- $apiVersion := (include "internal.network.ingress.apiVersion" .context) -}}
{{- if or (eq $apiVersion "extensions/v1beta1") (eq $apiVersion "networking.k8s.io/v1beta1") -}}
servicePort: {{ .servicePort }}
{{- else -}}
service:
  name: {{ .serviceName }}
  port:
    {{- if typeIs "string" .servicePort }}
    name: {{ .servicePort }}
    {{- else if or (typeIs "int" .servicePort) (typeIs "float64" .servicePort) }}
    number: {{ .servicePort | int }}
    {{- end }}
{{- end -}}
{{- end -}}

---

{{- define "internal.network.ingress.supportsPathType" -}}
{{- if (semverCompare "<1.18-0" (include "charts.capabilities.kubeVersion" .)) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

---

{{/*
  API Version for Ingress
==============================
  Compatibilities on API verions depend on Kubernetes versions.
    - <1.14.0  ==> extensions/v1beta1
    - <1.19.0  ==> networking.k8s.io/v1beta1
    - higher   ==> networking.k8s.io/v1
*/}}
{{- define "internal.network.ingress.apiVersion" -}}
{{- if .Values.exposure.ingress -}}
{{- if .Values.exposure.ingress.apiVersion -}}
{{- .Values.exposure.ingress.apiVersion -}}
{{- else if semverCompare "<1.14.0" (include "charts.capabilities.kubeVersion" .) -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19.0" (include "charts.capabilities.kubeVersion" .) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- else if semverCompare "<1.14.0" (include "charts.capabilities.kubeVersion" .) -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19.0" (include "charts.capabilities.kubeVersion" .) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}