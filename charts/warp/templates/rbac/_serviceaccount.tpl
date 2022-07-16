{{/*
  Create the name of the service account to use.
*/}}
{{- define "api.rbac.serviceAccount.name" -}}
{{- if .Values.serviceAccount -}}
{{- if .Values.serviceAccount.create -}}
{{- coalesce .Values.serviceAccount.name .Values.namespace.name .Release.Name "default" }}
{{- else }}
{{- print "default" }}
{{- end -}}
{{- else }}
{{- print "default" }}
{{- end -}}
{{- end -}}

---

{{- define "api.rbac.serviceAccount" -}}
{{/*
  ServiceAccount
*/}}
{{- if .Values.serviceAccount -}}
{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "charts.rbac.serviceAccount.name" . }}
  namespace: {{ include "charts.core.namespace.name" . }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{ .Values.serviceAccount.annotations }}
  {{- end }}
{{- end }}
---
{{- end -}}
{{- end -}}