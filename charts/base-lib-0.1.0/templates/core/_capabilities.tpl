{{/*
  Kubernetes version
==============================
*/}}
{{- define "charts.core.capabilities.kubeVersion" -}}
{{- default .Values.kubeVersion .Capabilities.KubeVersion.Version -}}
{{- end -}}

{{/*
  API Version for Ingress
==============================
  Compatibilities on API verions depend on Kubernetes versions.
    - <1.14.0  ==> extensions/v1beta1
    - <1.19.0  ==> networking.k8s.io/v1beta1
    - higher   ==> networking.k8s.io/v1
*/}}
{{- define "charts.core.capabilities.ingress.apiVersion" -}}
{{- if .Values.exposure.ingress -}}
{{- if .Values.exposure.ingress.apiVersion -}}
{{- .Values.exposure.ingress.apiVersion -}}
{{- else if semverCompare "<1.14.0" (include "charts.core.capabilities.kubeVersion" .) -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19.0" (include "charts.core.capabilities.kubeVersion" .) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- else if semverCompare "<1.14.0" (include "charts.core.capabilities.kubeVersion" .) -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19.0" (include "charts.core.capabilities.kubeVersion" .) -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}